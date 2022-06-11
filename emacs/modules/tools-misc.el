;;
;; Tools - Misc
;;

;; Conf
(require 'generic-x)
(add-to-list 'auto-mode-alist '("\\.aws/credentials\\'" . conf-mode))

;; Makefile
(defun mtk/setup-makefile-mode ()
  (setq-local indent-tabs-mode t))
(add-hook 'makefile-mode-hook 'mtk/setup-makefile-mode)

;; Dockerfile
(add-hook 'dockerfile-mode-hook #'lsp)
