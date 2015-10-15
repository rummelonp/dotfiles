;; Extension

;; helm
(require 'helm-config)
(add-hook 'helm-after-initialize-hook
          '(lambda ()
             (define-key helm-map (kbd "C-M-v") 'helm-previous-page)))

;; helm-git-files
(require 'helm-git-files)

;; cua
(cua-mode t)
(setq cua-enable-cua-keys nil)

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

;; point-undo
(require 'point-undo)

;; undohist
(require 'undohist)
(undohist-initialize)

;; git-gutter
(require 'git-gutter)

;; popwin
(require 'popwin)
(popwin-mode 1)
(add-to-list 'popwin:special-display-config '("*Backtrace*"))
(add-to-list 'popwin:special-display-config '("*Warnings*"))

;; migemo
(require 'migemo)
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
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)

;; anzu
(require 'anzu)
(global-anzu-mode +1)
(setq anzu-mode-lighter "")
(setq anzu-deactivate-region t)
(setq anzu-search-threshold 1000)
(setq anzu-use-migemo t)

;; visual-regexp
(require 'visual-regexp)

;; expand-region
(require 'expand-region)

;; multiple-cursors
(require 'multiple-cursors)
