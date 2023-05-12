;;
;; OS - MacOS
;;

(require 'osx-osascript)

;; Functions
(defun rmp/darwin-open (name)
  (osascript-run-str (concat "tell application \"" name "\" to activate window")))

(defun rmp/darwin-open-terminal ()
  (interactive)
  (rmp/darwin-open "Terminal"))

;; Key Bindings
(bind-key "C-x C-t" 'rmp/darwin-open-terminal)
