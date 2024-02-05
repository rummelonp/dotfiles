;;
;; Lang - Perl
;;

(add-to-list 'auto-mode-alist '("\\.t\\'" . perl-mode))

(add-hook 'perl-mode-hook #'lsp)
