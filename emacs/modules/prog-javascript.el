;;
;; Prog - JavaScript
;;

;; TypeScript
(define-derived-mode rmp/web-typescript-mode web-mode "Web[TS]")
(add-to-list 'auto-mode-alist '("\\.js\\'"     . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"     . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'"    . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.astro\\'"  . rmp/web-typescript-mode))

(defun rmp/setup-typescript-mode ()
  (setq-local lsp-enabled-clients '(ts-ls vls astro-ls eslint))
  (lsp)
  (setq-local company-backends '(company-capf)))
(add-hook 'typescript-mode-hook 'rmp/setup-typescript-mode)
(add-hook 'rmp/web-typescript-mode-hook 'rmp/setup-typescript-mode)

;; JSON
(with-eval-after-load 'json-mode
  (bind-key "M-s-l" 'json-mode-beautify json-mode-map))
