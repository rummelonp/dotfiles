;;;; languages - conf

;;; generic x
(require 'generic-x)

;;; shell script mode
(add-to-list 'auto-mode-alist '("\\.zsh" . shell-script-mode))

;;; conf space mode
(add-to-list 'auto-mode-alist '("\\.conf$" . conf-space-mode))
(add-to-list 'auto-mode-alist '("\\.screenrc$" . conf-space-mode))

;;; nginx mode
(autoload 'nginx-mode "nginx-mode" nil t)
(add-to-list 'auto-mode-alist '("/etc/nginx/" . nginx-mode))

;;; yaml mode
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml.sample$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
