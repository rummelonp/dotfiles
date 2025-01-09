;;
;; Prog - Perl
;;

(add-to-list 'auto-mode-alist '("\\.pl\\'"   . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'"   . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'"    . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.psgi\\'" . cperl-mode))

(defun rmp/cperl-imenu-create-index ()
  (let (index)
    ;; constant
    (let (list)
      (goto-char (point-min))
      (while (re-search-forward "^\\s-*use\\s-*constant\\s-+\\([^ ]+\\)" nil t)
        (push (cons (format "constant %s" (match-string 1)) (match-beginning 1)) index)))

    ;; sub
    (let (list)
      (goto-char (point-min))
      (while (re-search-forward "^\\s-*sub\\s-+\\([_a-zA-Z][^ ]+\\)" nil t)
        (push (cons (format "sub %s" (match-string 1)) (match-beginning 1)) index)))

    ;; subtest
    (let (list)
      (goto-char (point-min))
      (while (re-search-forward "^\\(\\s-*\\)subtest\\s-+\\(['\"]\\)\\([^\1\r\n]+\\)\\2" nil t)
        (push (cons (format "%ssubtest \"%s\"" (match-string 1) (match-string 3)) (match-beginning 3)) index)))

    (sort index (lambda (a b) (< (cdr a) (cdr b))))))

(defun rmp/setup-cperl-mode ()
  (run-hooks 'prog-mode-hook)
  (lsp)
  (add-hook 'before-save-hook 'lsp-format-buffer t t)
  (setq-local imenu-create-index-function 'rmp/cperl-imenu-create-index))

(add-hook 'cperl-mode-hook 'rmp/setup-cperl-mode)
