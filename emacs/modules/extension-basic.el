;;
;; Extension - Basic
;;

;; dired
(with-eval-after-load 'dired
  (require 'dired-x)
  (require 'dired+)
  (bind-keys :map dired-mode-map
             ("F" . dired-create-empty-file)
             ("r" . wdired-change-to-wdired-mode)))
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; recentf
(with-eval-after-load 'recentf
  (require 'recentf-ext))

;; misc
(require 'bind-key)
(require 'savekill)
(undohist-initialize)
(require 'point-undo)
(require 'magit)
(add-hook 'magit-mode-hook 'magit-delta-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
