;;;; Language - Web

;;; HTML
;; html-mode.el
(add-to-list 'auto-mode-alist '("\\.html$" . html-mode))
;; rhtml-mode.el
(autoload 'rhtml-mode "rhtml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))
;; rhtml-mode.el
(autoload 'haml-mode "haml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
;; rhtml-mode.el
(autoload 'slim-mode "slim-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.slim$" . slim-mode))
;; zencoding-code.el
(autoload 'zencoding-mode "zencoding-mode" nil t)
(add-hook 'html-mode-hook 'zencoding-mode)
(setq zencoding-indentation 2)

;;; Stylesheet
;; css-mode.el
(autoload 'css-mode "css-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(setq css-indent-offset 2)
;; scss-mode.el
(autoload 'scss-mode "scss-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq scss-compile-at-save nil)

;;; JavaScript
;; js.el
(require 'js)
(setq js-indent-level 2)
;; js2-mode.el
(defalias 'javascript-generic-mode 'js2-mode)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(setq js2-basic-offset 2)
;; coffee-mode.el
(autoload 'coffee-mode "coffee-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(setq coffee-tab-width 2)

;;; mmm-mode.el
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
;; Configuration
(mmm-add-classes
 '((html-css
    :submode css-mode
    :front "<style[^>]*>\n"
    :back  "</style>")
   (html-js
    :submode js-mode
    :front "<script[^>]*>\n"
    :back  "</script>")))
;; .html
(mmm-add-mode-ext-class nil "\\.html$" 'html-css)
(mmm-add-mode-ext-class nil "\\.html$" 'html-js)
;; .erb
(mmm-add-mode-ext-class nil "\\.erb$" 'html-css)
(mmm-add-mode-ext-class nil "\\.erb$" 'html-js)
