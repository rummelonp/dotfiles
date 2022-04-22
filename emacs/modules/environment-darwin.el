;;
;; Environment - Darwin
;;

(require 'osx-osascript)

;;; Functions
;; copy
(defun mtk/darwin-copy-current-directory ()
  (interactive)
  (shell-command-to-string "pwd | perl -pe 's/(\r|\n)//' | pbcopy"))

(defun mtk/darwin-copy-current-file-path ()
  (interactive)
  (shell-command-to-string (concat "echo " buffer-file-name " | perl -pe 's/(\r|\n)//' | pbcopy")))

;; open
(defun mtk/darwin-open (name)
  (osascript-run-str (concat "tell application \"" name "\" to activate window")))

(defun mtk/darwin-open-terminal ()
  (interactive)
  (mtk/darwin-open "Terminal"))

(defun mtk/darwin-open-tweetbot ()
  (interactive)
  (mtk/darwin-open "Tweetbot"))

;;; Key bindings
(global-set-key (kbd "C-x C-t") 'mtk/darwin-open-terminal)
(global-set-key (kbd "s-E") 'mtk/darwin-open-tweetbot)
