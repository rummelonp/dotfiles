;;;; extension - basic

;;; wdired
(require 'wdired)
;; key bind
(define-key dired-mode-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;; cua
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;; recentf
;; configuration
(setq recentf-max-menu-items 100000)
(setq recentf-max-save-items 100000)
(setq recentf-max-saved-items 100000)
(setq recentf-auto-cleanup 'never)
(setq recentf-auto-save-timer
      (run-with-idle-timer 30 t 'recentf-save-list))
;; extension
(require 'recentf-ext)

;;; savekill
(require 'savekill)

;;; undohist
(require 'undohist)
(undohist-initialize)

;;; redo+
(require 'redo+)
(setq undo-no-redo t)
(setq undo-limit 100000)
(setq undo-strong-limit 100000)

;;; point-undo
(require 'point-undo)
