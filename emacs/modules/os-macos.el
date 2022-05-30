;;
;; OS - MacOS
;;

(require 'osx-osascript)

;; Functions
(defun mtk/darwin-open (name)
  (osascript-run-str (concat "tell application \"" name "\" to activate window")))

(defun mtk/darwin-open-terminal ()
  (interactive)
  (mtk/darwin-open "Terminal"))

(defun mtk/darwin-open-tweetbot ()
  (interactive)
  (mtk/darwin-open "Tweetbot"))

;; Key Bindings
(bind-key "C-x C-t" 'mtk/darwin-open-terminal)
(bind-key "s-E" 'mtk/darwin-open-tweetbot)
