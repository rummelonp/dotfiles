;;;; Extension - Window

(defvar active-primary-fg "black")
(defvar active-primary-bg "#1aa6b1")
(defvar active-secondary-fg "white")
(defvar active-secondary-bg "gray40")
(defvar active-dark-fg "white")
(defvar active-dark-bg "grey22")
(defvar inactive-fg "gray80")
(defvar inactive-bg "#181a26")

;;; neotree.el
(require 'neotree)
(defun neotree-left (arg)
  (interactive "P")
  (let* ((path (neo-buffer--get-filename-current-line))
         (file-p (and path (not (file-directory-p path)))))
    (cond (file-p
           (neotree-previous-line))
          ((neo-buffer--expanded-node-p path)
           (neo-buffer--set-expand path nil)
           (neo-buffer--refresh t))
          (t
           (neotree-select-up-node)))))
(defun neotree-right (arg)
  (interactive "P")
  (let* ((path (neo-buffer--get-filename-current-line))
         (file-p (and path (not (file-directory-p path)))))
    (cond (file-p
           (neotree-next-line))
          ((not (neo-buffer--expanded-node-p path))
           (neo-buffer--set-expand path t)
           (neo-buffer--refresh t))
          (t
           (neotree-select-down-node)))))
(define-key neotree-mode-map (kbd "<left>") 'neotree-left)
(define-key neotree-mode-map (kbd "<right>") 'neotree-right)
(define-key neotree-mode-map (kbd "C-.") 'neotree-hidden-file-toggle)

;;; powerline.el
(defpowerline powerline-buffer-id nil)
(powerline-default-theme)
(set-face-attribute 'mode-line nil :foreground active-secondary-fg :background active-secondary-bg)
(set-face-attribute 'powerline-active1 nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground active-dark-fg :background active-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground inactive-fg :background inactive-bg)

;;; tabbar.el
(with-eval-after-load 'tabbar
  ;; Face
  (set-face-attribute 'tabbar-default nil :background inactive-bg :height 1.0)
  (set-face-attribute 'tabbar-selected nil :foreground active-primary-fg :background active-primary-bg :box nil)
  (set-face-attribute 'tabbar-selected-modified nil :foreground active-primary-fg :background active-primary-bg :box nil)
  (set-face-attribute 'tabbar-unselected nil :foreground inactive-fg :background inactive-bg :box nil)
  (set-face-attribute 'tabbar-modified nil :foreground inactive-fg :background inactive-bg :box nil)
  (set-face-attribute 'tabbar-separator nil :foreground inactive-bg :background inactive-bg)
  ;; Remove buttons
  (dolist
      (button
       '(tabbar-buffer-home-button
         tabbar-scroll-left-button
         tabbar-scroll-right-button))
    (set button (cons
                 (cons "" nil)
                 (cons "" nil))))
  ;; Customize list
  (setq tabbar-buffer-list-function
        '(lambda ()
           (cl-remove-if
            '(lambda (buffer)
               (cl-find (aref (buffer-name buffer) 0) " *"))
            (buffer-list))))
  ;; Customize group
  (setq tabbar-buffer-groups-function
        '(lambda ()
           (list
            (let ((name (symbol-name major-mode)))
              (cond ((or (equal name "html-mode")
                         (equal name "rhtml-mode")
                         (equal name "vue-mode"))
                     "vue-mode")
                    ((or (equal name "css-mode")
                         (equal name "scss-mode"))
                     "vue-mode")
                    ((or (equal name "typescript-mode")
                         (equal name "js2-mode")
                         (equal name "json-mode"))
                     "vue-mode")
                    (t name)))))))

;;; popwin.el
(with-eval-after-load 'popwin
  (add-to-list 'popwin:special-display-config '("*Backtrace*"))
  (add-to-list 'popwin:special-display-config '("*Warnings*"))
  (add-to-list 'popwin:special-display-config '("*Compile-Log*")))
