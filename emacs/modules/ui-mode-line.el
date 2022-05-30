;;
;; UI - Mode Line
;;

;; Powerline
(require 'powerline)

(defpowerline powerline-buffer-id
  (if buffer-file-name
      (all-the-icons-icon-for-file buffer-file-name)
  (all-the-icons-icon-for-buffer)))

(powerline-default-theme)

(set-face-attribute 'mode-line nil :foreground line-light-fg :background line-light-bg)
(set-face-attribute 'powerline-active1 nil :foreground line-primary-fg :background line-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground line-dark-fg :background line-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground line-inactive-fg :background line-inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground line-inactive-fg :background line-inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground line-inactive-fg :background line-inactive-bg)

;; Diminish
(defun mtk/setup-diminish ()
  (diminish 'abbrev-mode)
  (diminish 'auto-fix-mode)
  (diminish 'cargo-minor-mode)
  ;; (diminish 'company-mode)
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
