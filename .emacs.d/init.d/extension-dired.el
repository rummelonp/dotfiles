;; Dired

;; extension
(require 'wdired)

;; keybind
(define-key dired-mode-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
