;; Extension

;; anything
(require 'anything-startup)

;; anything project
(require 'anything-project)

;; anything yaetags
(require 'anything-yaetags)

;; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;; recentf
(setq recentf-max-menu-items 100000)
(setq recentf-max-save-items 100000)
(setq recentf-max-saved-items 100000)
(setq recentf-auto-cleanup 'never)
(setq recentf-auto-save-timer
      (run-with-idle-timer 30 t 'recentf-save-list))
(require 'recentf-ext)

;; savekill
(require 'savekill)

;; redo+
(require 'redo+)
(setq undo-no-redo t)
(setq undo-limit 100000)
(setq undo-strong-limit 100000)

;; point undo
(require 'point-undo)

;; undohist
(require 'undohist)
(undohist-initialize)

;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(add-to-list 'popwin:special-display-config '("^\\*anything.*\\*$" :regexp t :height 20))
(add-to-list 'popwin:special-display-config '("*Backtrace*"))
(add-to-list 'popwin:special-display-config '("*Warnings*"))

;; jaunte
(require 'jaunte)

;; migemo
(require 'migemo)
(setq migemo-command "/usr/local/bin/cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(cond (darwin-p
       (setq migemo-dictionary "/usr/local/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict"))
      (linux-p
       (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")))
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
