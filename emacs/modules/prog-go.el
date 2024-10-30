;;
;; Prog - Go
;;

(defun rmp/setup-go-mode ()
  (lsp)
  (add-hook 'before-save-hook #'lsp-format-buffer t t))

(add-hook 'go-mode-hook 'rmp/setup-go-mode)

(with-eval-after-load 'go-mode
  (bind-keys :map go-mode-map
             ("C-c C-v" . go-test-current-file)
             ("C-c C-e" . go-test-current-test)
             ("C-c C-r" . go-test-current-project)))
