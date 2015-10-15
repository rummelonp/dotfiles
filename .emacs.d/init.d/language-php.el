;;;; language - php

;;; php mode
(autoload 'php-mode "php-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-hook 'php-mode-hook
          '(lambda()
             ;; configuration
             (setq tab-width 2)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 2)))
