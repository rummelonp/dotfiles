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

;; anything
(defun anything-git-files-or-recentf ()
  (interactive)
  (if (anything-git-files:git-p)
      (anything-git-files)
    (anything-recentf)))

;; tabbar
(defun tabbar-sort-tab ()
  (interactive)
  (let* ((tabset (tabbar-current-tabset 't))
         (tabs (tabbar-tabs tabset)))
    (if (and tabset tabs)
        (progn
          (set tabset (sort tabs (lambda (b1 b2)
                                   (string-lessp (buffer-file-name (car b1))
                                                 (buffer-file-name (car b2))))))
          (put tabset 'template nil)
          (tabbar-display-update)))))

;; auto complete
(defun auto-complete-auto-start-enable ()
  (interactive)
  (setq ac-auto-start t))

(defun auto-complete-auto-start-disable ()
  (interactive)
  (setq ac-auto-start nil))
