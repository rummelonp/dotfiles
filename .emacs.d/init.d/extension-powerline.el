;; Powerline

(require 'powerline)

;; style
(setq powerline-arrow-shape 'arrow14)

;; face
(set-face-attribute
 'mode-line nil
 :foreground "black"
 :background "#1aa6b1"
 :box nil)
(set-face-attribute
 'mode-line-inactive nil
 :foreground "gray80"
 :background "#181a26"
 :box nil)

;; format
(defpowerline row     "%l")
(defpowerline column  "%c")
(defpowerline time    "%M")
