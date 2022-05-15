;;
;; Language - Web
;;

;; html
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"  . web-mode))

(with-eval-after-load 'web-mode
  (require 'company-web-html))

(defun mtk/setup-web-mode ()
  (setq-local company-backends
              '((company-web-html company-dabbrev-code company-dabbrev))))
(add-hook 'web-mode-hook 'mtk/setup-web-mode)
(add-hook 'web-mode-hook 'emmet-mode)

;; typescript
(define-derived-mode mtk/web-typescript-mode web-mode "Web[TS]")
(add-to-list 'auto-mode-alist '("\\.js\\'"  . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . mtk/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . mtk/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . mtk/web-typescript-mode))

(defun mtk/setup-typescript-mode ()
  (lsp)
  (setq-local company-backends '(company-capf)))
(add-hook 'typescript-mode-hook 'mtk/setup-typescript-mode)
(add-hook 'mtk/web-typescript-mode-hook 'mtk/setup-typescript-mode)

;; json
(with-eval-after-load 'json-mode
  (bind-key "M-s-l" 'json-mode-beautify json-mode-map))
