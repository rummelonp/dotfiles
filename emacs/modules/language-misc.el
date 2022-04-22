;;
;; Language - Misc
;;

;; generic-x
(require 'generic-x)

;; shell-script-mode
(add-to-list 'auto-mode-alist '("\\.zsh" . shell-script-mode))

;; conf-mode
(add-to-list 'auto-mode-alist '("\\.conf$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.aws/config$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.aws/credentials$" . conf-mode))

;; nginx-mode
(autoload 'nginx-mode "nginx-mode" nil t)
(add-to-list 'auto-mode-alist '("/etc/nginx/" . nginx-mode))

;; yaml-mode
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; markdown-mode
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;; plantuml-mode
(autoload 'plantuml-mode "plantuml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.puml$" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.iuml$" . plantuml-mode))
