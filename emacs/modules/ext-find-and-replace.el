;;;; Extension - Find and replace

;;; migemo.el
(require 'migemo)
;; Configuration
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
;; Key bind
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)

;;; visual-regexp.el
(require 'visual-regexp)

;;; anzu.el
(require 'anzu)
