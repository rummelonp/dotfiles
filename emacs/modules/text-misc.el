;;
;; Text - Misc
;;

;; Conf
(require 'generic-x)
(add-to-list 'auto-mode-alist '("\\.aws/credentials\\'" . conf-mode))

;; YAML
(add-to-list 'auto-mode-alist '("\\.ya?ml\\.tmpl\\'" . yaml-mode))
(add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)

;; XML
(add-to-list 'auto-mode-alist '("\\.icls\\'" . nxml-mode))
(add-hook 'nxml-mode-hook 'rainbow-mode)
