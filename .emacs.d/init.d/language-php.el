;;;; Language - PHP

;;; php-mode.el
(autoload 'php-mode "php-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\/views?.*\\.php$" . html-mode))

;; Toggle major mode between html-mode and php-mode
(add-hook 'php-mode-hook
          '(lambda ()
             (define-key php-mode-map (kbd "C--") 'html-mode)))
(add-hook 'html-mode-hook
          '(lambda ()
             (define-key html-mode-map (kbd "C--") 'php-mode)))
