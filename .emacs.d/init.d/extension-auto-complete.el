;; Auto Complete

;; yasnippet
(require 'yasnippet)
(yas-global-mode t)

;; auto complete
(require 'auto-complete-config)
(global-auto-complete-mode t)

;; add yasnippet source
(defun ac-common-setup ()
  (add-to-list 'ac-sources 'ac-source-yasnippet))

;; add major modes
(add-to-list 'ac-modes 'rhtml-mode)
(add-to-list 'ac-modes 'scss-mode)
(add-to-list 'ac-modes 'less-css-mode)
(add-to-list 'ac-modes 'coffee-mode)

;; configuration
(ac-config-default)
(ac-set-trigger-key "C-i")
(setq ac-auto-show-menu 0.5)
(setq ac-quick-help-delay 0.5)

;; menu configuration
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(define-key ac-mode-map (kbd "C-x ?") 'ac-last-quick-help)
