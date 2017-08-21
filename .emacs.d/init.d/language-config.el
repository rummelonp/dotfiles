;;;; Languages - Config

;;; generic-x.el
(require 'generic-x)

;;; shell-script-mode.el
(add-to-list 'auto-mode-alist '("\\.zsh" . shell-script-mode))

;;; conf-space-mode.el
(add-to-list 'auto-mode-alist '("\\.conf$" . conf-space-mode))

;;; nginx-mode.el
(autoload 'nginx-mode "nginx-mode" nil t)
(add-to-list 'auto-mode-alist '("/etc/nginx/" . nginx-mode))

;;; yaml-mode.el
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;; markdown-mode.el
(autoload 'markdown-mode "markdown-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
