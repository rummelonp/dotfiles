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

;;; Tabbar
(require 'tabbar)
;; face
(set-face-attribute 'tabbar-default nil :background inactive-bg :height 1.0)
(set-face-attribute 'tabbar-selected nil :foreground active-primary-fg :background active-primary-bg :box nil)
(set-face-attribute 'tabbar-selected-modified nil :foreground active-primary-fg :background active-primary-bg :box nil)
(set-face-attribute 'tabbar-unselected nil :foreground inactive-fg :background inactive-bg :box nil)
(set-face-attribute 'tabbar-modified nil :foreground inactive-fg :background inactive-bg :box nil)
(set-face-attribute 'tabbar-separator nil :foreground inactive-bg :background inactive-bg)
;; remove buttons
(let ((blank-button (cons (cons "" nil) (cons "" nil))))
  (setq tabbar-buffer-home-button blank-button)
  (setq tabbar-scroll-left-button blank-button)
  (setq tabbar-scroll-right-button blank-button))
;; customize list
(defun mtk/tabbar-buffer-list-function ()
  (cl-remove-if
   '(lambda (buffer)
      (cl-find (aref (buffer-name buffer) 0) " *"))
   (buffer-list)))
(setq tabbar-buffer-list-function 'mtk/tabbar-buffer-list-function)
;; customize group
(defun mtk/tabbar-buffer-group-function ()
  (list
   (cond ((member major-mode
                  '(web-mode
                    html-mode nxml-mode
                    css-mode scss-mode
                    js-mode js-jsx-mode javascript-mode
                    typescript-mode mtk/web-typescript-mode
                    json-mode jsonc-mode))
          "web-mode")
         (t (symbol-name major-mode)))))
(setq tabbar-buffer-groups-function 'mtk/tabbar-buffer-group-function)
(tabbar-mode t)

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
