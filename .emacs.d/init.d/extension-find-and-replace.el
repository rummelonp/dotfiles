;;;; extension - find and replace

;;; migemo
(require 'migemo)
;; configuration
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-isearch-min-length 2)
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(cond (darwin-p
       (setq migemo-dictionary "/usr/local/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict"))
      (linux-p
       (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")))
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
;; key bind
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)

;;; anzu
(require 'anzu)
(global-anzu-mode +1)
;; configuration
(setq anzu-mode-lighter "")
(setq anzu-deactivate-region t)
(setq anzu-search-threshold 1000)
(setq anzu-use-migemo t)

;;; visual regexp
(require 'visual-regexp)
