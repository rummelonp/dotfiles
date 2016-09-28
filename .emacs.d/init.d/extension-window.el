;;;; Extension - Window

;;; powerline.el
(require 'powerline)
(setq powerline-default-separator nil)
(setq powerline-display-mule-info nil)
(setq powerline-display-hud nil)
(defpowerline powerline-buffer-id nil)
(powerline-default-theme)
(set-face-attribute
 'mode-line nil
 :foreground "white"
 :background "gray40"
 :box nil)
(set-face-attribute
 'powerline-active1 nil
 :foreground "black"
 :background "#1aa6b1")
(set-face-attribute
 'powerline-active2 nil
 :foreground "white"
 :background "grey22")
(set-face-attribute
 'mode-line-inactive nil
 :foreground "white"
 :background "#181a26"
 :box nil)
(set-face-attribute
 'powerline-inactive1 nil
 :foreground "gray80"
 :background "#181a26")
(set-face-attribute
 'powerline-inactive2 nil
 :foreground "gray80"
 :background "#181a26")

;;; tabbar.el
(require 'tabbar)
(tabbar-mode t)
;; Face
(set-face-attribute
 'tabbar-default nil
 :family "Monaco"
 :background "#181a26"
 :height 1.0)
(set-face-attribute
 'tabbar-unselected nil
 :foreground "gray80"
 :background "#181a26"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :foreground "black"
 :background "#1aa6b1"
 :box nil)
(set-face-attribute
 'tabbar-modified nil
 :foreground "green"
 :background "#181a26"
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :foreground "#181a26"
 :background "#181a26")
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
         (remove-if
          '(lambda (buffer)
             (find (aref (buffer-name buffer) 0) " *"))
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
                       (equal name "nxml-mode"))
                   "html-mode")
                  ((or (equal name "scss-mode")
                       (equal name "less-css-mode")
                       (equal name "css-mode"))
                   "css-mode")
                  ((or (equal name "coffee-mode")
                       (equal name "js2-mode"))
                   "js2-mode")
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
