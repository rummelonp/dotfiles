;;;; Extension - Basic

;;; dired-x.el
(require 'dired-x)

;;; wdired.el
(require 'wdired)
;; Key bind
(define-key dired-mode-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key dired-mode-map (kbd "C--") 'dired-omit-mode)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;; cua.el
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;; uniquify.el
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;; recentf.el
;; Configuration
(setq recentf-max-menu-items 100000)
(setq recentf-max-save-items 100000)
(setq recentf-max-saved-items 100000)
(setq recentf-auto-cleanup 'never)
(setq recentf-auto-save-timer
      (run-with-idle-timer 30 t 'recentf-save-list))
;; Extension
(require 'recentf-ext)

;;; savekill.el
(require 'savekill)
(setq savekill-max-saved-items 1000)

;;; undohist.el
(require 'undohist)
(undohist-initialize)

;;; undotree.el
(require 'undo-tree)
(global-undo-tree-mode)

;;; rainbow-delimiters.el
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
