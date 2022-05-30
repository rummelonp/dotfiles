;;
;; Tools - LSP
;;

(with-eval-after-load #'lsp-mode
  (bind-keys :map lsp-mode-map
             ("C-x C-o" . consult-lsp-diagnostics)
             ("C-x ."   . lsp-execute-code-action)
             ("C-."     . lsp-describe-thing-at-point)
             ("C-M-."   . lsp-find-definition)
             ("M-s-l"   . lsp-format-buffer)))
