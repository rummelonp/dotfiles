;;
;; Prog - Go
;;

(defun rmp/setup-go-mode ()
  (lsp)
  (add-hook 'before-save-hook #'lsp-format-buffer t t))

(add-hook 'go-mode-hook 'rmp/setup-go-mode)
