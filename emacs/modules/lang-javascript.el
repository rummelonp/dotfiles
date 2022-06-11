;;
;; Lang - JavaScript
;;

;; TypeScript
(define-derived-mode mtk/web-typescript-mode web-mode "Web[TS]")
(add-to-list 'auto-mode-alist '("\\.js\\'"  . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . mtk/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . mtk/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . mtk/web-typescript-mode))

(defun mtk/setup-typescript-mode ()
  (setq-local lsp-enabled-clients '(ts-ls vls eslint))
  (lsp)
  (setq-local company-backends '(company-capf)))
(add-hook 'typescript-mode-hook 'mtk/setup-typescript-mode)
(add-hook 'mtk/web-typescript-mode-hook 'mtk/setup-typescript-mode)

;; JSON
(with-eval-after-load 'json-mode
  (bind-key "M-s-l" 'json-mode-beautify json-mode-map))
