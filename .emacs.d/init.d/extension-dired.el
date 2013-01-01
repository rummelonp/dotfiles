;; Dired

;; extension
(require 'wdired)

;; function
(defun popwin:dired-display-file ()
  (interactive)
  (popwin:find-file (dired-get-file-for-visit)))

;; keybind
(define-key dired-mode-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key dired-mode-map (kbd "C-o") 'popwin:dired-display-file)
(define-key dired-mode-map "o" 'dired-display-file)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
