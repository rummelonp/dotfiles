;;;; General - Key bindings

;;; Darwin modifier
(when darwin-p
  (setq mac-control-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-right-command-modifier 'hyper))

;;; Backslash
(global-set-key (kbd "M-(J\(B") "\\")

;;; consult.el
(global-set-key (kbd "C-x C-a") 'consult-recent-file)
(global-set-key (kbd "C-x C-f") 'project-find-file)      ;; find-file
(global-set-key (kbd "C-x f")   'find-file)              ;; set-fill-column
(global-set-key (kbd "C-x C-d") 'mtk/neotree-toggle)     ;; list-directory
(global-set-key (kbd "C-x d")   'project-find-dir)       ;; dired
(global-set-key (kbd "C-x C-b") 'consult-project-buffer) ;; list-buffer
(global-set-key (kbd "C-x b")   'consult-buffer)         ;; switch-to-buffer
(global-set-key (kbd "C-x g")   'consult-git-grep)
(global-set-key (kbd "C-x C-m") 'consult-imenu)
(global-set-key (kbd "C-x m")   'consult-imenu-multi)    ;; compose-mail
(global-set-key (kbd "C-x C-y") 'yank-from-kill-ring)
(global-set-key (kbd "M-g M-g") 'consult-line)           ;; goto-line
(global-set-key (kbd "M-g g")   'consult-line-multi)     ;; goto-line

;;; Frame
(global-set-key (kbd "C-z") nil) ;; suspend-frame

;;; Window
(global-set-key (kbd "C-x `") 'delete-other-windows)                  ;; next-error
(global-set-key (kbd "C-t")   'mtk/next-window-or-split-horizontally) ;; transpose-charas
(global-set-key (kbd "C-S-t") 'mtk/prev-window)
(global-set-key (kbd "M-t")   'delete-window)                         ;; transpose-words
;; tabbar.el
(global-set-key (kbd "C-x j")   'mtk/tabbar-sort-tab)
(global-set-key (kbd "C-x C-n") 'tabbar-forward-tab)    ;; set-goal-column
(global-set-key (kbd "C-x C-p") 'tabbar-backward-tab)   ;; mark-page
(global-set-key (kbd "C-x n")   'tabbar-forward-group)  ;; save-buffers-kill-terminal
(global-set-key (kbd "C-x p")   'tabbar-backward-group)

;;; Basic
;; Server
(global-set-key (kbd "C-x C-c") 'server-edit) ;; save-buffers-kill-terminal
;; Buffer
(global-set-key (kbd "M-k") 'kill-this-buffer) ;; kill-sentence
;; Newline and indent
(global-set-key (kbd "C-m")   'newline-and-indent)      ;; newline
(global-set-key (kbd "C-j")   'indent-new-comment-line) ;; electric-newline-and-maybe-indent
(global-set-key (kbd "C-i")   'indent-for-tab-command)  ;; indent-for-tab-command
(global-set-key (kbd "M-i")   'delete-indentation)      ;; tab-to-tab-stop
(global-set-key (kbd "C-x i") 'indent-region)           ;; insert-file
;; Cursor
(global-set-key (kbd "M-a")   'beginning-of-defun) ;; backward-sentence
(global-set-key (kbd "M-e")   'end-of-defun)       ;; forward-sentence
(global-set-key (kbd "M-f")   'forward-sexp)       ;; forward-word
(global-set-key (kbd "M-b")   'backward-sexp)      ;; backward-word
(global-set-key (kbd "C-M-a") 'backward-sentence)  ;; beginning-of-defun
(global-set-key (kbd "C-M-e") 'forward-sentence)   ;; end-of-fun
(global-set-key (kbd "C-M-f") 'forward-word)       ;; forward-sexp
(global-set-key (kbd "C-M-b") 'backward-word)      ;; backward-sexp
;; Scroll
(global-set-key (kbd "C-v")   'scroll-up-command) ;; scroll-up-command
(global-set-key (kbd "C-M-v") 'scroll-down)       ;; scroll-other-window
;; Kill
(global-set-key (kbd "C-w") 'kill-ring-save) ;; kill-region
(global-set-key (kbd "M-w") 'kill-region)    ;; kill-ring-save
(global-set-key (kbd "C-y") 'yank)           ;; yank
(global-set-key (kbd "C-M-y") 'yank-pop)
;; Undo
(global-set-key (kbd "C-_")   'undo) ;; undo
(global-set-key (kbd "C-/")   'undo) ;; undo
(global-set-key (kbd "C-M-_") 'redo) ;; undo-redo
(global-set-key (kbd "C-M-/") 'redo) ;; dabbrev-completion
;; Comment
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
;; Configuration
(global-set-key (kbd "C--") 'toggle-truncate-lines) ;; negative-argument
;; Help
(global-set-key (kbd "M-?") 'help-for-help) ;; xref-find-references

;;; Company
;; company.el
(global-set-key (kbd "C-x C-.") 'company-complete)

;;; Find and replace
;; visual-regexp.el
(global-set-key (kbd "M-%")   'vr/query-replace) ;; query-replace
(global-set-key (kbd "C-M-%") 'vr/replace)       ;; query-replace-regexp
;; anzu.el
(global-set-key (kbd "C-,")   'anzu-query-replace-at-cursor-thing)
(global-set-key (kbd "C-M-,") 'anzu-query-replace-at-cursor)

;;; Editor enhancement
;; multiple-cursors.el
(global-set-key (kbd "C->")   'mc/mark-next-like-this)
(global-set-key (kbd "C-M-<") 'mc/unmark-next-like-this)
(global-set-key (kbd "C-<")   'mc/mark-previous-like-this)
(global-set-key (kbd "C-M->") 'mc/unmark-previous-like-this)
(global-set-key (kbd "M-@")   'mc/mark-all-like-this)        ;; mark-word
;; expand-region.el
(global-set-key (kbd "C-@")   'er/expand-region)   ;; set-mark-command
(global-set-key (kbd "C-M-@") 'er/contract-region) ;; mark-sexp
