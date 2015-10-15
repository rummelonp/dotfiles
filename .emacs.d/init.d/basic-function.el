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

;; helm
(defun helm-git-files-or-recentf ()
  (interactive)
  (if (helm-git-files:git-p)
      (helm-git-files)
    (helm-recentf)))

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
(defun auto-complete-toggle-auto-start ()
  (interactive)
  (if ac-auto-start
      (setq ac-auto-start nil)
    (setq ac-auto-start t)))

;; before save hook
(defun toggle-delete-trailing-whitespace ()
  (interactive)
  (if (find 'delete-trailing-whitespace before-save-hook)
      (remove-hook 'before-save-hook 'delete-trailing-whitespace)
    (add-hook 'before-save-hook 'delete-trailing-whitespace)))
