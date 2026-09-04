;;
;; Tools - Claude
;;

(eval-when-compile (require 'consult))
(require 'project)

;; The command uses consult internals, which carry no autoload cookie.
(declare-function consult--file-action "consult")
(declare-function consult--file-preview "consult")
(declare-function consult--lookup-candidate "consult")
(declare-function consult--read "consult")

(defvar rmp/claude-config-directory nil
  "Claude Code configuration directory.
When nil, follow Claude Code: $CLAUDE_CONFIG_DIR, or \"~/.claude\".")

(defvar rmp/claude-plans-directory nil
  "Directory holding Claude Code plan files.
When nil, resolve it the way Claude Code does: `plansDirectory' from
`rmp/claude-settings-files', falling back to \"plans\" under the config
directory.  A relative path is expanded against the project root.")

(defvar rmp/claude-worktrees-directory ".claude/worktrees"
  "Where Claude Code creates worktrees, relative to the repository root.
Claude Code has no setting for this; the path is baked into it.")

(defvar rmp/claude-settings-files
  '("~/.claude/settings.json"
    ".claude/settings.json"
    ".claude/settings.local.json")
  "Claude Code settings files, in increasing order of precedence.
Relative names are expanded against the project root.")

(defvar rmp/claude-plan-title-width 60
  "Column budget for the title, so that the time columns stay aligned.")

(defvar rmp/claude-plan-time-format "%Y-%m-%d %H:%M"
  "Format of the time columns.")

(defvar rmp/consult-claude-plan-history nil
  "Minibuffer history of `rmp/consult-claude-plan'.")

(defun rmp/claude-config-dir ()
  "Return the Claude Code configuration directory."
  (file-name-as-directory
   (expand-file-name (or rmp/claude-config-directory
                         (getenv "CLAUDE_CONFIG_DIR")
                         "~/.claude"))))

(defun rmp/claude-project-root ()
  "Return the repository root of `default-directory'.
A Claude worktree resolves to the repository it was created from, which is
also how Claude Code itself recovers the root."
  (let* ((project (project-current))
         (root (file-name-as-directory
                (expand-file-name (if project
                                      (project-root project)
                                    default-directory))))
         (worktrees (file-name-as-directory rmp/claude-worktrees-directory))
         ;; Strip the worktree name, leaving the directory holding the worktrees.
         (parent (file-name-directory (directory-file-name root))))
    (if (string-suffix-p worktrees parent)
        (substring parent 0 (- (length parent) (length worktrees)))
      root)))

(defun rmp/claude-settings-plans-directory (root)
  "Return `plansDirectory' from Claude Code settings, or nil."
  (let (value)
    (dolist (file rmp/claude-settings-files value)
      (let ((path (expand-file-name file root)))
        (when (file-readable-p path)
          (condition-case nil
              (with-temp-buffer
                (insert-file-contents path)
                (let ((dir (gethash "plansDirectory"
                                    (json-parse-buffer :object-type 'hash-table))))
                  (when (stringp dir)
                    (setq value dir))))
            (error nil)))))))

(defun rmp/claude-plans-dir (root)
  "Return the plans directory Claude Code would use for ROOT."
  (let ((default (expand-file-name "plans" (rmp/claude-config-dir)))
        (setting (rmp/claude-settings-plans-directory root)))
    (file-name-as-directory
     (cond (rmp/claude-plans-directory
            (expand-file-name rmp/claude-plans-directory root))
           ((null setting) default)
           (t
            ;; Claude Code discards a `plansDirectory' pointing outside the
            ;; project root and falls back to the default.
            (let ((dir (file-name-as-directory (expand-file-name setting root))))
              (if (string-prefix-p root dir) dir default)))))))

(defun rmp/claude-plan-files (dir)
  "Return the plan files in DIR."
  (when (file-directory-p dir)
    (directory-files dir t "\\.md\\'")))

(defun rmp/claude-worktree-roots (root)
  "Return the roots of the Claude worktrees of ROOT."
  (let ((dir (expand-file-name rmp/claude-worktrees-directory root)))
    (when (file-directory-p dir)
      (seq-filter #'file-directory-p
                  (directory-files dir t directory-files-no-dot-files-regexp)))))

(defun rmp/claude-plan-entries (root)
  "Return (FILE . WORKTREE) for every plan reachable from ROOT.
WORKTREE is nil for the main worktree.  A worktree contributes nothing when
its plans resolve to the same directory as the main one, and its plans are
shadowed by same-named plans of the main worktree.  The order is arbitrary;
`rmp/claude-plan-candidates' sorts the result."
  (let* ((dir (rmp/claude-plans-dir root))
         (files (rmp/claude-plan-files dir))
         (names (mapcar #'file-name-nondirectory files))
         (entries (mapcar (lambda (file) (cons file nil)) files)))
    (dolist (worktree (rmp/claude-worktree-roots root) entries)
      (let ((worktree-dir (rmp/claude-plans-dir (file-name-as-directory worktree))))
        (unless (equal worktree-dir dir)
          (dolist (file (rmp/claude-plan-files worktree-dir))
            (unless (member (file-name-nondirectory file) names)
              (push (cons file (file-name-nondirectory
                                (directory-file-name worktree)))
                    entries))))))))

(defun rmp/claude-plan-birth-times (files)
  "Return a hash table mapping each of FILES to its birth time.
`file-attributes' carries no birth time, so ask stat once for all FILES."
  (let ((table (make-hash-table :test #'equal)))
    (when files
      (with-temp-buffer
        (when (zerop (apply #'call-process "stat" nil t nil
                            (if rmp/darwin-p "-f" "-c")
                            (if rmp/darwin-p "%B %N" "%W %n")
                            files))
          (goto-char (point-min))
          (while (re-search-forward "^\\([0-9]+\\) \\(.+\\)$" nil t)
            (let ((seconds (string-to-number (match-string 1)))
                  (file (match-string 2)))
              ;; GNU stat reports 0 where the filesystem has no birth time.
              (unless (zerop seconds)
                (puthash file (seconds-to-time seconds) table)))))))
    table))

(defun rmp/claude-plan-title (file)
  "Return the first line of FILE without its leading \"#\"."
  (with-temp-buffer
    (condition-case nil
        (insert-file-contents file nil 0 4096)
      (error nil))
    (let ((line (buffer-substring-no-properties (point-min) (line-end-position))))
      (if (string-match "\\`#+[ \t]+" line)
          (substring line (match-end 0))
        line))))

(defun rmp/claude-plan-pad (string width)
  "Pad or truncate STRING to exactly WIDTH columns."
  (truncate-string-to-width string width nil ?\s t))

(defun rmp/claude-plan-format-time (time)
  "Format TIME for a column, or return a placeholder of the same width."
  (let ((formatted (format-time-string rmp/claude-plan-time-format (or time 0))))
    (if time formatted (rmp/claude-plan-pad "-" (string-width formatted)))))

(defun rmp/claude-plan-candidate (widths plan)
  "Return the completion candidate of PLAN, with columns padded to WIDTHS.
WIDTHS is (FILE-NAME-WIDTH . TITLE-WIDTH).  The candidate carries the plan's
path for `consult--lookup-candidate' and for the embark file actions.  The
modification time is left out; marginalia annotates it as a relative age."
  (let* ((file (plist-get plan :file))
         (worktree (plist-get plan :worktree))
         (candidate
          (concat (rmp/claude-plan-pad (file-name-nondirectory file) (car widths))
                  "  " (propertize (rmp/claude-plan-pad (plist-get plan :title)
                                                        (cdr widths))
                                   'face 'completions-annotations)
                  "  " (propertize (rmp/claude-plan-format-time (plist-get plan :birth))
                                   'face 'shadow)
                  (when worktree
                    (concat "  " (propertize (format "[%s]" worktree) 'face 'italic))))))
    (add-text-properties 0 (length candidate)
                         (list 'consult--candidate file
                               'multi-category (cons 'file file))
                         candidate)
    candidate))

(defun rmp/claude-plan-candidates ()
  "Return plan candidates for the current project, most recently changed first."
  (let* ((root (rmp/claude-project-root))
         (entries (rmp/claude-plan-entries root)))
    (unless entries
      (user-error "No Claude plans in %s" (rmp/claude-plans-dir root)))
    (let* ((births (rmp/claude-plan-birth-times (mapcar #'car entries)))
           (plans (mapcar (lambda (entry)
                            (let ((file (car entry)))
                              (list :file file
                                    :worktree (cdr entry)
                                    :mtime (file-attribute-modification-time
                                            (file-attributes file))
                                    :birth (gethash file births)
                                    :title (rmp/claude-plan-title file))))
                          entries))
           (plans (sort plans
                        :key (lambda (plan) (plist-get plan :mtime))
                        :lessp #'time-less-p
                        :reverse t))
           (widths (cons (seq-max
                          (mapcar (lambda (plan)
                                    (string-width (file-name-nondirectory
                                                   (plist-get plan :file))))
                                  plans))
                         (min rmp/claude-plan-title-width
                              (seq-max
                               (mapcar (lambda (plan)
                                         (string-width (plist-get plan :title)))
                                       plans))))))
      (mapcar (apply-partially #'rmp/claude-plan-candidate widths) plans))))

(defun rmp/consult-claude-plan ()
  "Open a Claude Code plan of the current project."
  (interactive)
  (require 'consult)
  (consult--file-action
   (consult--read (rmp/claude-plan-candidates)
                  :prompt "Claude plan: "
                  :category 'multi-category
                  :require-match t
                  :sort nil
                  :lookup #'consult--lookup-candidate
                  :state (consult--file-preview)
                  :history 'rmp/consult-claude-plan-history)))
