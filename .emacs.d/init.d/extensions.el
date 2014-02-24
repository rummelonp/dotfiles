;; Extension

;; anything
(require 'anything-startup)

;; anything-git-files
(require 'anything-git-files)

;; anything yaetags
(require 'anything-yaetags)

;; dash-at-point
(require 'dash-at-point)

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
(add-to-list 'popwin:special-display-config '("^\\*anything.*\\*$" :regexp t :height 20))
(add-to-list 'popwin:special-display-config '("*Backtrace*"))
(add-to-list 'popwin:special-display-config '("*Warnings*"))

;; jaunte
(require 'jaunte)

;; ace-jump-mode
(require 'ace-jump-mode)
(defun add-keys-to-ace-jump-mode (prefix c)
  (define-key global-map
    (read-kbd-macro (concat prefix (string c)))
    `(lambda ()
       (interactive)
       (funcall #'ace-jump-word-mode ,c))))
(loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c))
(loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c))
(loop for c from ?! to ?~ do (add-keys-to-ace-jump-mode "H-" c))

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

;; auto-highlight-symbol
(setq auto-highlight-symbol-mode-map t)
(require 'auto-highlight-symbol-config)

;; highlight-symbol
(require 'highlight-symbol)
