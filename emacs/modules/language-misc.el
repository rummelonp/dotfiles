;;
;; Language - Misc
;;

(require 'generic-x)

(add-to-list 'auto-mode-alist '("\\.aws/credentials\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("/TODO\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.[pi]uml\\'" . plantuml-mode))

(defun mtk/setup-makefile-mode ()
  (setq-local indent-tabs-mode t))
(add-hook 'makefile-mode-hook 'mtk/setup-makefile-mode)
