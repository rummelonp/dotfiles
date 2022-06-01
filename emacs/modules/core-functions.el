;;
;; Core - Functions
;;

;; Command Protection
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Aliases
(defalias 'yes-or-no-p 'y-or-n-p)

;; Window Functions
(defun mtk/next-window-or-split-horizontally ()
  (interactive)
  (let* ((win-len (length (window-list)))
         (current-win (selected-window))
         (treemacs-win (treemacs-get-local-window))
         (next-win (next-window)))
    (cond ((or (eq win-len 1)
               (and treemacs-win
                    (not (eq current-win treemacs-win))
                    (eq win-len 2)))
           (split-window-horizontally)
           (other-window 1))
          ((eq next-win treemacs-win)
           (other-window 2))
          (t
           (other-window 1)))))

(defun mtk/prev-window ()
  (interactive)
  (other-window -1))

;; Treemacs Functions
(defun mtk/treemacs-toggle ()
  (interactive)
  (let* ((path (or buffer-file-name (expand-file-name default-directory))))
    (if (eq (selected-window) (treemacs-get-local-window))
        (delete-window (treemacs-get-local-window))
      (treemacs-select-window))))

;; CentaurTabs Functions
(defun mtk/centaur-tabs-group-cycle ()
  (interactive)
  (pcase centaur-tabs-buffer-groups-function
    ('mtk/centaur-tabs-group-by-project
     (setq centaur-tabs-buffer-groups-function 'mtk/centaur-tabs-group-by-major-mode)
     (message "Group tabs by major-mode"))
    (_
     (setq centaur-tabs-buffer-groups-function 'mtk/centaur-tabs-group-by-project)
     (message "Group tabs by project")))
  (centaur-tabs-display-update))

(defun mtk/centaur-tabs-list-cycle ()
  (interactive)
  (pcase centaur-tabs-buffer-list-function
    ('mtk/centaur-tabs-list-all
     (setq centaur-tabs-buffer-list-function 'mtk/centaur-tabs-list-hide-emacs)
     (message "Hide *Emacs* tabs"))
    (_
     (setq centaur-tabs-buffer-list-function 'mtk/centaur-tabs-list-all)
     (message "Show all tabs")))
  (centaur-tabs-display-update))

(defun mtk/centaur-tabs-sort ()
  (interactive)
  (let* ((tabset (centaur-tabs-current-tabset 't))
         (tabs (centaur-tabs-tabs tabset)))
    (if (and tabset tabs)
        (progn
          (set tabset (sort tabs (lambda (b1 b2)
                                   (string-lessp (buffer-file-name (car b1))
                                                 (buffer-file-name (car b2))))))
          (put tabset 'template nil)
          (centaur-tabs-display-update)))))

;; Misc Functions
(defun mtk/copy-current-directory ()
  (interactive)
  (kill-new (file-name-directory buffer-file-name)))

(defun mtk/copy-current-file-path ()
  (interactive)
  (kill-new buffer-file-name))

(defun mtk/insert-class-name-from-file-name ()
  (interactive)
  (insert
   (let ((fn (capitalize (file-name-nondirectory
                          (file-name-sans-extension
				                   (or (buffer-file-name)
				                       (buffer-name (current-buffer))))))))
     (replace-regexp-in-string "_" "" fn t t))))
