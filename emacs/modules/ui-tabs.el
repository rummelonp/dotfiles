;;
;; UI - Tabs
;;

(require 'centaur-tabs)
(centaur-tabs-mode)

;; Font
(if (find-font (font-spec :name "HackGen"))
    (centaur-tabs-change-fonts "HackGen" 160)
  (centaur-tabs-change-fonts "Monaco" 140))

;; Face
(set-face-attribute 'tab-line nil :background line-inactive-bg)
(set-face-attribute 'centaur-tabs-selected nil :foreground line-primary-fg :background line-primary-bg)
(set-face-attribute 'centaur-tabs-selected-modified nil :foreground line-primary-fg :background line-primary-bg)
(set-face-attribute 'centaur-tabs-unselected nil :foreground line-dark-fg :background line-dark-bg)
(set-face-attribute 'centaur-tabs-unselected-modified nil :foreground line-dark-fg :background line-dark-bg)

;; Customize Navigation Buttons
(defun centaur-tabs-line-format--buttons ()
  (if (and centaur-tabs-show-navigation-buttons (display-graphic-p))
      (list
       (propertize (centaur-tabs-button-tab centaur-tabs-down-tab-text)
                   'local-map centaur-tabs-down-tab-map
                   'help-echo "Change tab group"))
    ""))

;; Customize Project Name
(defun centaur-tabs-project-name ()
  (let ((project-path (project-root (project-current))))
    (if project-path
	      (format "Project: %s"
                (file-name-nondirectory
                 (directory-file-name project-path)))
      centaur-tabs-common-group-name)))

;; Customize Group
(defun mtk/centaur-tabs-group-by-major-mode ()
  (list
   (cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
	       (memq major-mode '(magit-process-mode
			                      magit-status-mode magit-diff-mode magit-log-mode
			                      magit-file-mode magit-blob-mode magit-blame-mode)))
     "*Emacs*")
    ((memq major-mode
           '(web-mode
             html-mode nxml-mode
             css-mode scss-mode
             js-mode js-jsx-mode javascript-mode
             typescript-mode mtk/web-typescript-mode
             json-mode jsonc-mode))
     "Web")
    (t
     (capitalize
      (replace-regexp-in-string
       "-" " "
       (replace-regexp-in-string
        "-mode" ""
        (symbol-name major-mode))))))))

(defun mtk/centaur-tabs-group-by-project ()
  (list
   (cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
	       (memq major-mode '(magit-process-mode
			                      magit-status-mode magit-diff-mode magit-log-mode
			                      magit-file-mode magit-blob-mode magit-blame-mode)))
     "*Emacs*")
    (t
     (centaur-tabs-get-group-name (current-buffer))))))

(setq centaur-tabs-buffer-groups-function 'mtk/centaur-tabs-group-by-major-mode)

;; Customize List
(defalias 'mtk/centaur-tabs-list-all 'centaur-tabs-buffer-list)

(defun mtk/centaur-tabs-list-hide-emacs ()
  (centaur-tabs-filter-out
   'centaur-tabs-hide-tab-cached
   (delq nil
         (cl-mapcar #'(lambda (b)
                        (cond
			                   ((eq (current-buffer) b) b)
			                   ((buffer-file-name b) b)
			                   ((cl-find (aref (buffer-name b) 0) " *") nil)
			                   ((buffer-live-p b) b)))
	                  (buffer-list)))))

(setq centaur-tabs-buffer-list-function 'mtk/centaur-tabs-list-hide-emacs)
