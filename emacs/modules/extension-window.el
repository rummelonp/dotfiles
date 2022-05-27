;;
;; Extension - Window
;;

;;; Variables
(defvar active-primary-fg "black")
(defvar active-primary-bg "#1aa6b1")
(defvar active-secondary-fg "white")
(defvar active-secondary-bg "gray40")
(defvar active-dark-fg "white")
(defvar active-dark-bg "grey22")
(defvar inactive-fg "gray80")
(defvar inactive-bg "#181a26")

;;; Treemacs
(require 'treemacs)
(require 'treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")
(bind-keys :map treemacs-mode-map
           ("+" . treemacs-create-dir)
           ("F" . treemacs-create-file)
           ("C" . treemacs-copy-file)
           ("D" . treemacs-delete-file)
           ("C-M-n" . treemacs-next-neighbour)
           ("C-M-p" . treemacs-previous-neighbour)
           ("M-n" . treemacs-next-project)
           ("M-p" . treemacs-previous-project))

;;; Powerline
(require 'powerline)
(defpowerline powerline-buffer-id
  (if buffer-file-name
      (all-the-icons-icon-for-file buffer-file-name)
  (all-the-icons-icon-for-buffer)))
(powerline-default-theme)
(set-face-attribute 'mode-line nil :foreground active-secondary-fg :background active-secondary-bg)
(set-face-attribute 'powerline-active1 nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground active-dark-fg :background active-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground inactive-fg :background inactive-bg)

;;; Centaur tabs
(require 'centaur-tabs)
(centaur-tabs-mode)
;; font
(if (find-font (font-spec :name "HackGen"))
    (centaur-tabs-change-fonts "HackGen" 160)
  (centaur-tabs-change-fonts "Monaco" 140))
;; face
(set-face-attribute 'tab-line nil :background inactive-bg)
(set-face-attribute 'centaur-tabs-selected nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'centaur-tabs-selected-modified nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'centaur-tabs-unselected nil :foreground active-dark-fg :background active-dark-bg)
(set-face-attribute 'centaur-tabs-unselected-modified nil :foreground active-dark-fg :background active-dark-bg)
;; customize navigation buttons
(defun centaur-tabs-line-format--buttons ()
  (if (and centaur-tabs-show-navigation-buttons (display-graphic-p))
      (list
       (propertize (centaur-tabs-button-tab centaur-tabs-down-tab-text)
                   'local-map centaur-tabs-down-tab-map
                   'help-echo "Change tab group"))
    ""))
;; customize project name
(defun centaur-tabs-project-name ()
  (let ((project-name (cdr (project-current))))
    (if project-name
	      (format "Project: %s"
                (file-name-nondirectory
                 (directory-file-name project-name)))
      centaur-tabs-common-group-name)))
;; customize group
(defun mtk/centaur-tabs-group-by-major-mode ()
  (list
   (cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
	       (memq major-mode '(magit-process-mode
			                      magit-status-mode magit-diff-mode magit-log-mode
			                      magit-file-mode magit-blob-mode magit-blame-mode)))
     "*Emacs*")
    ((memq major-mode
           '(web-mode
             html-mode nxml-mode
             css-mode scss-mode
             js-mode js-jsx-mode javascript-mode
             typescript-mode mtk/web-typescript-mode
             json-mode jsonc-mode))
     "Web")
    (t
     (capitalize
      (replace-regexp-in-string
       "-" " "
       (replace-regexp-in-string
        "-mode" ""
        (symbol-name major-mode))))))))
(defun mtk/centaur-tabs-group-by-project ()
  (list
   (cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
	       (memq major-mode '(magit-process-mode
			                      magit-status-mode magit-diff-mode magit-log-mode
			                      magit-file-mode magit-blob-mode magit-blame-mode)))
     "*Emacs*")
    (t
     (centaur-tabs-get-group-name (current-buffer))))))
(setq centaur-tabs-buffer-groups-function 'mtk/centaur-tabs-group-by-major-mode)
;; customize list
(defalias 'mtk/centaur-tabs-list-all 'centaur-tabs-buffer-list)
(defun mtk/centaur-tabs-list-hide-emacs ()
  (centaur-tabs-filter-out
   'centaur-tabs-hide-tab-cached
   (delq nil
         (cl-mapcar #'(lambda (b)
                        (cond
			                   ((eq (current-buffer) b) b)
			                   ((buffer-file-name b) b)
			                   ((cl-find (aref (buffer-name b) 0) " *") nil)
			                   ((buffer-live-p b) b)))
	                  (buffer-list)))))
(setq centaur-tabs-buffer-list-function 'mtk/centaur-tabs-list-hide-emacs)

;;; Popwin
(with-eval-after-load 'popwin
  (add-to-list 'popwin:special-display-config '("*Backtrace*"   :noselect t))
  (add-to-list 'popwin:special-display-config '("*Warnings*"    :noselect t))
  (add-to-list 'popwin:special-display-config '("*Compile-Log*" :noselect t)))

;;; Diminish
(defun mtk/setup-diminish ()
  (diminish 'abbrev-mode)
  (diminish 'auto-fix-mode)
  (diminish 'cargo-minor-mode)
  (diminish 'company-mode)
  (diminish 'company-box-mode)
  (diminish 'eldoc-mode)
  (diminish 'elisp-slime-nav-mode)
  (diminish 'emmet-mode)
  (diminish 'flutter-test-mode)
  (diminish 'git-gutter-mode)
  (diminish 'highlight-indent-guides-mode)
  (diminish 'lsp-lens-mode)
  (diminish 'mmm-mode)
  (diminish 'rainbow-mode)
  (diminish 'robe-mode)
  (diminish 'rspec-mode)
  (diminish 'undo-tree-mode)
  (diminish 'which-key-mode))
(add-hook 'after-change-major-mode-hook 'mtk/setup-diminish)
