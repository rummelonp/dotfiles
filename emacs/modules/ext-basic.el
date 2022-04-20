;;;; Extension - Basic

;;; dired-x.el
(require 'dired-x)

;;; wdired.el
(require 'wdired)
;; Key bind
(define-key dired-mode-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key dired-mode-map "F" 'dired-create-empty-file)
(define-key dired-mode-map "f" 'dired-create-empty-file)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;; cua.el
(cua-mode t)

;;; uniquify.el
(require 'uniquify)

;;; recentf.el
(require 'recentf-ext)

;;; savekill.el
(require 'savekill)

;;; undohist.el
(require 'undohist)
(undohist-initialize)

;;; undotree.el
(require 'undo-tree)
(global-undo-tree-mode)

;;; rainbow-mode.el
(require 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)

;;; rainbow-delimiters.el
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
