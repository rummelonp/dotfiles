;;
;; Language - Ruby
;;

(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook #'lsp)
