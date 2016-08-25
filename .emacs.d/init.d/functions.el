;;;; Basic - Functions

;;; Configuration
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; Aliaes
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Window
(defun next-window-or-split-horizontally ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(defun prev-window ()
  (interactive)
  (other-window -1))

;;; helm.el
(defun helm-git-files-or-recentf ()
  (interactive)
  (if (helm-git-files:git-p)
      (helm-git-files)
    (helm-recentf)))

;;; tabbar.el
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
