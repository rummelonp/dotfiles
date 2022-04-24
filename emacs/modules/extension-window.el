;;
;; Extension - Window
;;

;; variables
(defvar active-primary-fg "black")
(defvar active-primary-bg "#1aa6b1")
(defvar active-secondary-fg "white")
(defvar active-secondary-bg "gray40")
(defvar active-dark-fg "white")
(defvar active-dark-bg "grey22")
(defvar inactive-fg "gray80")
(defvar inactive-bg "#181a26")

;; neotree
(require 'neotree)
(defun mtk/neotree-left (arg)
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
(defun mtk/neotree-right (arg)
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
(define-key neotree-mode-map (kbd "<left>") 'mtk/neotree-left)
(define-key neotree-mode-map (kbd "<right>") 'mtk/neotree-right)
(define-key neotree-mode-map (kbd "+") 'neotree-create-node)
(define-key neotree-mode-map (kbd "F") 'neotree-create-node)
(define-key neotree-mode-map (kbd "C") 'neotree-copy-node)
(define-key neotree-mode-map (kbd "R") 'neotree-rename-node)
(define-key neotree-mode-map (kbd "D") 'neotree-delete-node)
(define-key neotree-mode-map (kbd "D") 'neotree-enter)
(define-key neotree-mode-map (kbd "C-.") 'neotree-hidden-file-toggle)

;; powerline
(require 'powerline)
(defpowerline powerline-buffer-id nil)
(powerline-default-theme)
(set-face-attribute 'mode-line nil :foreground active-secondary-fg :background active-secondary-bg)
(set-face-attribute 'powerline-active1 nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground active-dark-fg :background active-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground inactive-fg :background inactive-bg)

;; tabbar
(with-eval-after-load 'tabbar
  ;; face
  (set-face-attribute 'tabbar-default nil :background inactive-bg :height 1.0)
  (set-face-attribute 'tabbar-selected nil :foreground active-primary-fg :background active-primary-bg :box nil)
  (set-face-attribute 'tabbar-selected-modified nil :foreground active-primary-fg :background active-primary-bg :box nil)
  (set-face-attribute 'tabbar-unselected nil :foreground inactive-fg :background inactive-bg :box nil)
  (set-face-attribute 'tabbar-modified nil :foreground inactive-fg :background inactive-bg :box nil)
  (set-face-attribute 'tabbar-separator nil :foreground inactive-bg :background inactive-bg)
  ;; remove buttons
  (let ((blank-button (cons (cons "" nil) (cons "" nil))))
    (setq tabbar-buffer-home-button blank-button)
    (setq tabbar-scroll-left-button blank-button)
    (setq tabbar-scroll-right-button blank-button))
  ;; customize list
  (defun mtk/tabbar-buffer-list-function ()
    (cl-remove-if
     '(lambda (buffer)
        (cl-find (aref (buffer-name buffer) 0) " *"))
     (buffer-list)))
  (setq tabbar-buffer-list-function 'mtk/tabbar-buffer-list-function)
  ;; customize group
  (defun mtk/tabbar-buffer-group-function ()
    (list
     (let ((name (symbol-name major-mode)))
       (cond ((or (equal name "web-mode")
                  (equal name "css-mode")
                  (equal name "scss-mode")
                  (equal name "js2-mode")
                  (equal name "typescript-mode")
                  (equal name "json-mode"))
              "web-mode")
             (t name)))))
  (setq tabbar-buffer-groups-function 'mtk/tabbar-buffer-group-function))

;; popwin
(with-eval-after-load 'popwin
  (add-to-list 'popwin:special-display-config '("*Backtrace*"))
  (add-to-list 'popwin:special-display-config '("*Warnings*"))
  (add-to-list 'popwin:special-display-config '("*Compile-Log*")))

;; diminish
(defun mtk/setup-diminish ()
  (require 'diminish)
  (diminish 'abbrev-mode)
  (diminish 'company-box-mode)
  (diminish 'eldoc-mode)
  (diminish 'git-gutter-mode)
  (diminish 'mmm-mode)
  (diminish 'rainbow-mode)
  (diminish 'robe-mode)
  (diminish 'undo-tree-mode))
(add-hook 'after-change-major-mode-hook 'mtk/setup-diminish)
