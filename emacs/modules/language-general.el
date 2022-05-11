;;
;; Language - General
;;

;; lsp-mode
(with-eval-after-load #'lsp-mode
  (bind-keys :map lsp-mode-map
             ("C-x C-o" . consult-lsp-diagnostics)
             ("C-x ."   . lsp-execute-code-action)
             ("C-."     . lsp-describe-thing-at-point)
             ("C-M-."   . lsp-find-definition)
             ("M-s-l"   . lsp-format-buffer)))

;; flycheck
(with-eval-after-load 'flycheck
  (defun mtk/flycheck-mode-line-status-text (&optional status)
    (let* ((active (powerline-selected-window-active))
           (text (pcase (or status flycheck-last-status-change)
                   (`not-checked "😴")
                   (`no-checker "😎")
                   (`running "🤔")
                   (`errored "😭")
                   (`finished
                    (let-alist (flycheck-count-errors flycheck-current-errors)
                      (if (or .error .warning)
                          (concat (when .error "😰") (when .warning "😥"))
                        "🤩")))
                   (`interrupted "🤯")
                   (`suspicious "🙃"))))
      (concat " " flycheck-mode-line-prefix text)))
  (setq flycheck-mode-line '(:eval (mtk/flycheck-mode-line-status-text))))
