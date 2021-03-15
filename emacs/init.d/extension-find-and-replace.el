;;;; Extension - Find and replace

;;; migemo.el
(require 'migemo)
;; Configuration
(setq migemo-command (find-if 'executable-find
                              '("/opt/homebrew/bin/cmigemo"
                                "/usr/local/bin/cmigemo")))
(setq migemo-options '("-q" "--emacs"))
(setq migemo-isearch-min-length 2)
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-dictionary (find-if 'file-exists-p
                                 '("/opt/homebrew/share/migemo/utf-8/migemo-dict"
                                   "/usr/local/share/migemo/utf-8/migemo-dict"
                                   "/usr/share/cmigemo/utf-8/migemo-dict")))
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
;; Key bind
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)

;;; visual-regexp.el
(require 'visual-regexp)

;;; anzu.el
(require 'anzu)
(global-anzu-mode +1)
;; Configuration
(setq anzu-mode-lighter "")
(setq anzu-search-threshold 1000)
(setq anzu-use-migemo t)
(setq anzu-replace-to-string-separator " => ")
