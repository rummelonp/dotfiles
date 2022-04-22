;;;; Language - Misc

;;; generic-x.el
(require 'generic-x)

;;; shell-script-mode.el
(add-to-list 'auto-mode-alist '("\\.zsh" . shell-script-mode))

;;; conf-mode.el
(add-to-list 'auto-mode-alist '("\\.conf$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.aws/config$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.aws/credentials$" . conf-mode))

;;; nginx-mode.el
(autoload 'nginx-mode "nginx-mode" nil t)
(add-to-list 'auto-mode-alist '("/etc/nginx/" . nginx-mode))

;;; yaml-mode.el
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;; markdown-mode.el
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;;; plantuml-mode.el
(autoload 'plantuml-mode "plantuml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.puml$" . plantuml-mode))
(add-to-list 'auto-mode-alist '("\\.iuml$" . plantuml-mode))
