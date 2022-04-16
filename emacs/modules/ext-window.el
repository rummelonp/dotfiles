;;;; Extension - Window

(defvar active-primary-fg "black")
(defvar active-primary-bg "#1aa6b1")
(defvar active-secondary-fg "white")
(defvar active-secondary-bg "gray40")
(defvar active-dark-fg "white")
(defvar active-dark-bg "grey22")
(defvar inactive-fg "gray80")
(defvar inactive-bg "#181a26")

;;; powerline.el
(require 'powerline)
(setq powerline-default-separator 'utf-8)
(setq powerline-display-mule-info nil)
(setq powerline-display-hud nil)
(defpowerline powerline-buffer-id nil)
(powerline-default-theme)
(set-face-attribute 'mode-line nil :foreground active-secondary-fg :background active-secondary-bg)
(set-face-attribute 'powerline-active1 nil :foreground active-primary-fg :background active-primary-bg)
(set-face-attribute 'powerline-active2 nil :foreground active-dark-fg :background active-dark-bg)
(set-face-attribute 'mode-line-inactive nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive1 nil :foreground inactive-fg :background inactive-bg)
(set-face-attribute 'powerline-inactive2 nil :foreground inactive-fg :background inactive-bg)

;;; tabbar.el
(require 'tabbar)
(tabbar-mode t)
;; Face
(set-face-attribute 'tabbar-default nil :background inactive-bg :height 1.0)
(set-face-attribute 'tabbar-selected nil :foreground active-primary-fg :background active-primary-bg :box nil)
(set-face-attribute 'tabbar-selected-modified nil :foreground active-primary-fg :background active-primary-bg :box nil)
(set-face-attribute 'tabbar-unselected nil :foreground inactive-fg :background inactive-bg :box nil)
(set-face-attribute 'tabbar-modified nil :foreground inactive-fg :background inactive-bg :box nil)
(set-face-attribute 'tabbar-separator nil :foreground inactive-bg :background inactive-bg)
(setq tabbar-separator '(1))
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
                       (equal name "haml-mode")
                       (equal name "slim-mode")
                       (equal name "vue-mode"))
                   "vue-mode")
                  ((or (equal name "css-mode")
                       (equal name "scss-mode")
                       (equal name "less-css-mode"))
                   "vue-mode")
                  ((or (equal name "typescript-mode")
                       (equal name "js2-mode")
                       (equal name "json-mode")
                       (equal name "coffee-mode"))
                   "vue-mode")
                  (t name))))))

;;; popwin.el
(require 'popwin)
(popwin-mode 1)
;; Configuration
(add-to-list 'popwin:special-display-config '("*Backtrace*"))
(add-to-list 'popwin:special-display-config '("*Warnings*"))

;;; git-gutter.el
(require 'git-gutter)
(global-git-gutter-mode t)
