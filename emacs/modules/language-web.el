;;
;; Language - Web
;;

(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.ts$" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(defun mtk/setup-web-mode ()
  (require 'company-web-html)
  (setq-local company-backends
              '((company-web-html company-dabbrev-code))))
(add-hook 'web-mode-hook 'mtk/setup-web-mode)
