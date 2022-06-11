;;
;; Lang - Web
;;

(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"  . web-mode))

(with-eval-after-load 'web-mode
  (require 'company-web-html))

(defun mtk/setup-web-mode ()
  (setq-local company-backends
              '((company-web-html company-dabbrev-code company-dabbrev))))
(add-hook 'web-mode-hook 'mtk/setup-web-mode)
(add-hook 'web-mode-hook 'emmet-mode)
