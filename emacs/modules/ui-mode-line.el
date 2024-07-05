;;
;; UI - Mode Line
;;

;; Powerline
(defpowerline powerline-buffer-id
  (if buffer-file-name
      (all-the-icons-icon-for-file buffer-file-name)
  (all-the-icons-icon-for-buffer)))

(powerline-default-theme)

(set-face-attribute 'mode-line nil :foreground rmp/line-light-fg :background rmp/line-light-bg)
(set-face-attribute 'powerline-active1 nil :foreground rmp/line-primary-fg :background rmp/line-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground rmp/line-dark-fg :background rmp/line-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground rmp/line-inactive-fg :background rmp/line-inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground rmp/line-inactive-fg :background rmp/line-inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground rmp/line-inactive-fg :background rmp/line-inactive-bg)

;; Diminish
(defun rmp/setup-diminish ()
  (diminish 'abbrev-mode)
  (diminish 'all-the-icons-dired-mode)
  (diminish 'auto-fix-mode)
  (diminish 'cargo-minor-mode)
  ;; (diminish 'company-mode)
  (diminish 'company-box-mode)
  (diminish 'copilot-mode)
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
(add-hook 'after-change-major-mode-hook 'rmp/setup-diminish)
