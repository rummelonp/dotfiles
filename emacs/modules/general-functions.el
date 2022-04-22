;;;; General - Functions

;;; Configuration
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;; Aliaes
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Window
(defun mtk/next-window-or-split-horizontally ()
  (interactive)
  (let* ((win-len (length (window-list)))
         (current-win (selected-window))
         (neotree-win (neo-global--get-window))
         (next-win (next-window)))
    (cond ((or (eq win-len 1)
               (and neotree-win
                    (not (eq current-win neotree-win))
                    (eq win-len 2)))
           (split-window-horizontally)
           (other-window 1))
          ((eq next-win neotree-win)
           (other-window 2))
          (t
           (other-window 1)))))

(defun mtk/prev-window ()
  (interactive)
  (other-window -1))

(defun mtk/neotree-toggle ()
  (interactive)
  (let* ((path (or buffer-file-name (expand-file-name default-directory)))
         (project (cdr (project-current nil path))))
    (if (eq (selected-window) (neo-global--get-window))
        (neotree-hide)
      (progn
        (if project
            (progn
              (neotree-dir project)
              (neotree-find path))
          (neo-global--open))
        (neo-global--select-window)))))

;;; tabbar.el
(defun mtk/tabbar-sort-tab ()
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

;;; Other
(defun mtk/insert-class-name-from-file-name ()
  (interactive)
  (insert
   (let ((fn (capitalize (file-name-nondirectory
                          (file-name-sans-extension
				                   (or (buffer-file-name)
				                       (buffer-name (current-buffer))))))))
     (replace-regexp-in-string "_" "" fn t t))))
