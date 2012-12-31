;; Tabbar

(require 'tabbar)
(tabbar-mode t)

;; delete button
(dolist
    (button
     '(tabbar-buffer-home-button
       tabbar-scroll-left-button
       tabbar-scroll-right-button))
  (set button (cons
               (cons "" nil)
               (cons "" nil))))

;; buffer
(setq tabbar-buffer-list-function
      '(lambda ()
         (remove-if
          '(lambda (buffer)
             (find (aref (buffer-name buffer) 0) " *"))
          (buffer-list))))

;; group
(setq tabbar-buffer-groups-function
      '(lambda ()
         (list
          (let ((name (symbol-name major-mode)))
            (cond ((or (equal name "coffee-mode")
                       (equal name "js2-mode"))
                   "js2-mode")
                  ((or (equal name "scss-mode")
                       (equal name "less-css-mode")
                       (equal name "css-mode"))
                   "css-mode")
                  (t name))))))

;; face
(set-face-attribute
 'tabbar-default nil
 :family "Monaco"
 :background "gray30"
 :height 1.0)
(set-face-attribute
 'tabbar-selected nil
 :foreground "gray10"
 :background "gray80"
 :box nil)
(set-face-attribute
 'tabbar-unselected nil
 :foreground "gray70"
 :background "gray30"
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :foreground "gray30"
 :background "gray30")
(setq tabbar-separator '(1))
