;;
;; Extension - Basic
;;

;; dired
(with-eval-after-load 'dired
  (require 'dired-x)
  (bind-keys :map dired-mode-map
             ("F" . dired-create-empty-file)
             ("r" . wdired-change-to-wdired-mode)))

;; recentf
(with-eval-after-load 'recentf
  (require 'recentf-ext))

;; misc
(require 'savekill)
(undohist-initialize)
(require 'point-undo)
(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
