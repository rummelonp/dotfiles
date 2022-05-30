;;
;; Core - Misc
;;

;; UI
(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Key Bindings
(require 'bind-key)

;; Undo
(undohist-initialize)
(require 'point-undo)

;; Dired
(with-eval-after-load 'dired
  (require 'dired-x)
  (require 'dired+)
  (bind-keys :map dired-mode-map
             ("F" . dired-create-empty-file)
             ("r" . wdired-change-to-wdired-mode)))
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; Editor
(with-eval-after-load 'recentf
  (require 'recentf-ext))
(require 'savekill)
