;; Languages

;; generic x
(require 'generic-x)

;; shell script
(add-to-list 'auto-mode-alist '("\\.zsh" . shell-script-mode))

;; conf space
(add-to-list 'auto-mode-alist '("\\.conf$" . conf-space-mode))
(add-to-list 'auto-mode-alist '("\\.screenrc$" . conf-space-mode))

;; nginx
(autoload 'nginx-mode "nginx-mode" nil t)
(add-to-list 'auto-mode-alist '("/etc/nginx/" . nginx-mode))

;; yaml
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml.sample$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; emacs lisp
(require 'eldoc-extension)
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'after-save-hook
          '(lambda ()
             (when (string-match "\\.el$" buffer-file-name)
               (byte-compile-file buffer-file-name))))
(define-key emacs-lisp-mode-map (kbd "C-.") 'find-function-at-point)

;; html
(add-to-list 'auto-mode-alist '("\\.html$" . html-mode))
(add-to-list 'auto-mode-alist '("\\.aspx$" . html-mode))

;; rhtml
(autoload 'rhtml-mode "rhtml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))

;; zencoding
(autoload 'zencoding-mode "zencoding-mode" nil t)
(add-hook 'html-mode-hook 'zencoding-mode)
(setq zencoding-indentation 2)

;; css
(autoload 'css-mode "css-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(setq css-indent-offset 2)

;; scss
(autoload 'scss-mode "scss-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq scss-compile-at-save nil)

;; js
(require 'js)
(setq js-indent-level 2)

;; js2
(defalias 'javascript-generic-mode 'js2-mode)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(setq js2-basic-offset 2)

;; coffee
(autoload 'coffee-mode "coffee-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(setq coffee-tab-width 2)

;; php
(autoload 'php-mode "php-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-hook 'php-mode-hook
          '(lambda()
             (setq tab-width 2)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 2)))

;; c sharp
(autoload 'csharp-mode "csharp-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))

;; haskell
(autoload 'haskell-mode "haskell-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))

;; mmm mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class nil "\\.erb$" 'html-css)
(mmm-add-mode-ext-class nil "\\.erb$" 'html-js)
(mmm-add-mode-ext-class nil "\\.html$" 'html-css)
(mmm-add-mode-ext-class nil "\\.html$" 'html-js)
(mmm-add-mode-ext-class nil "\\.html$" 'html-php)
(mmm-add-mode-ext-class nil "\\.php$" 'html-css)
(mmm-add-mode-ext-class nil "\\.php$" 'html-js)
(mmm-add-mode-ext-class nil "\\.php$" 'html-php)
(mmm-add-classes
 '((html-css
    :submode css-mode
    :front "<style[^>]*>\n"
    :back  "</style>")
   (html-js
    :submode js-mode
    :front "<script[^>]*>\n"
    :back  "</script>")
   (html-smarty
    :submode smarty-mode
    :include-front t
    :include-back t
    :front "{{"
    :back "}}")
   (html-php
    :submode php-mode
    :front "<?php"
    :back "?>")))
