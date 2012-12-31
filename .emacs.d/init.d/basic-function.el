;; Function

;; indent
(defun indent-and-untabify-buffer ()
  (interactive)
  (indent-region (point-min) (point-max))
  (untabify (point-min) (point-max)))

;; split window
(defun next-window-or-split-vertically ()
  (interactive)
  (when (one-window-p)
    (split-window-vertically))
  (other-window 1))

(defun next-window-or-split-horizontally ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun prev-window-or-split-horizontally ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window -1))
