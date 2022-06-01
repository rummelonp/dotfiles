;;
;; Lang - Misc
;;

;; Shell Script
(add-to-list 'auto-mode-alist '("\\.zshrc.local\\'" . sh-mode))
(add-hook 'sh-mode-hook 'flycheck-posframe-mode)

;; XML
(add-to-list 'auto-mode-alist '("\\.icls\\'" . nxml-mode))
(add-hook 'nxml-mode-hook 'rainbow-mode)

;; YAML
(add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)

;; PlantUML
(add-to-list 'auto-mode-alist '("\\.[pi]uml\\'" . plantuml-mode))
