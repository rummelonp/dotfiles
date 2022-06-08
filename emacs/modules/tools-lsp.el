;;
;; Tools - LSP
;;

(with-eval-after-load #'lsp-mode
  (bind-keys :map lsp-mode-map
             ("C-."     . lsp-describe-thing-at-point)
             ("C-M-."   . lsp-find-definition)
             ("C-,"     . lsp-rename)
             ("M-,"     . lsp-execute-code-action)
             ("M-s-l"   . lsp-format-buffer)
             ("C-x C-o" . consult-lsp-diagnostics)))
