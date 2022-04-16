;;;; Language - Web

;;; HTML
;; html-mode.el
(add-to-list 'auto-mode-alist '("\\.html$" . html-mode))
;; rhtml-mode.el
(autoload 'rhtml-mode "rhtml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))
(add-to-list 'auto-mode-alist '("\\.tt$" . rhtml-mode))
;; vue-mode.el
(autoload 'vue-mode "vue-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.vue$" . vue-mode))

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
(setq js2-strict-missing-semi-warning nil)
;; typescript-mode.el
(require 'typescript-mode)
(setq typescript-indent-level 2)
;; rjsx-mode.el
(require 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.tsx$" . rjsx-mode))
;; json-mode.el
(autoload 'json-mode "json-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

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
