;; Extension

;; anything
(require 'anything-startup)

;; wdired
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

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
(require 'recentf)
(recentf-mode t)

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

;; auto complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-delay 0.1)
(setq ac-auto-show-menu 0.5)
(setq ac-quick-help-delay 0.5)
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(define-key ac-mode-map (kbd "C-x ?") 'ac-last-quick-help)

;; popwin
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(push '("^\\*anything.*\\*$" :regexp t :height 20) popwin:special-display-config)

;; migemo
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(cond (darwin-p
       (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict"))
      (linux-p
       (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")))
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
