;;
;; Extension - Basic
;;

;; dired
(with-eval-after-load 'dired
  (require 'dired-x)
  (define-key dired-mode-map (kbd "C-t") 'mtk/next-window-or-split-horizontally)
  (define-key dired-mode-map "F" 'dired-create-empty-file)
  (define-key dired-mode-map "f" 'dired-create-empty-file)
  (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode))

;; recentf
(with-eval-after-load 'recentf
  (require 'recentf-ext))

;; misc
(require 'savekill)
(undohist-initialize)
(require 'point-undo)
(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
