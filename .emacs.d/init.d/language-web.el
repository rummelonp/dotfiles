;;;; language - web

;;; html
;; html mode
(add-to-list 'auto-mode-alist '("\\.html$" . html-mode))
;; rhtml mode
(autoload 'rhtml-mode "rhtml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))
;; zencoding code
(autoload 'zencoding-mode "zencoding-mode" nil t)
(add-hook 'html-mode-hook 'zencoding-mode)
(setq zencoding-indentation 2)

;;; stylesheet
;; css mode
(autoload 'css-mode "css-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(setq css-indent-offset 2)
;; scss mode
(autoload 'scss-mode "scss-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq scss-compile-at-save nil)

;;; javascript
;; js
(require 'js)
(setq js-indent-level 2)
;; js2 mode
(defalias 'javascript-generic-mode 'js2-mode)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(setq js2-basic-offset 2)
;; coffee mode
(autoload 'coffee-mode "coffee-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(setq coffee-tab-width 2)

;;; mmm mode
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
;; configuration
(mmm-add-classes
 '((html-css
    :submode css-mode
    :front "<style[^>]*>\n"
    :back  "</style>")
   (html-js
    :submode js-mode
    :front "<script[^>]*>\n"
    :back  "</script>")
   (html-php
    :submode php-mode
    :front "<?php"
    :back "?>")))
;; html
(mmm-add-mode-ext-class nil "\\.html$" 'html-css)
(mmm-add-mode-ext-class nil "\\.html$" 'html-js)
(mmm-add-mode-ext-class nil "\\.html$" 'html-php)
;; rhtml
(mmm-add-mode-ext-class nil "\\.erb$" 'html-css)
(mmm-add-mode-ext-class nil "\\.erb$" 'html-js)
;; php
(mmm-add-mode-ext-class nil "\\.php$" 'html-css)
(mmm-add-mode-ext-class nil "\\.php$" 'html-js)
(mmm-add-mode-ext-class nil "\\.php$" 'html-php)
