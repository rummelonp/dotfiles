;;
;; Prog - Perl
;;

(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'"  . cperl-mode))

(defun rmp/setup-cperl-mode ()
  (run-hooks 'prog-mode-hook)
  (lsp)
  (add-hook 'before-save-hook 'lsp-format-buffer t t))

(add-hook 'cperl-mode-hook 'rmp/setup-cperl-mode)
