;;;; Darwin

;;; Functions
;; Copy
(defun mtk/darwin-copy-current-directory ()
  (interactive)
  (shell-command-to-string "pwd | perl -pe 's/(\r|\n)//' | pbcopy"))

(defun mtk/darwin-copy-current-file-path ()
  (interactive)
  (shell-command-to-string (concat "echo " buffer-file-name " | perl -pe 's/(\r|\n)//' | pbcopy")))

;; Open
(defun mtk/darwin-open (name)
  (shell-command-to-string (concat "echo 'tell application \"" name "\" to activate window' | osascript")))

(defun mtk/darwin-open-terminal ()
  (interactive)
  (mtk/darwin-open "Terminal"))

(defun mtk/darwin-open-tweetbot ()
  (interactive)
  (mtk/darwin-open "Tweetbot"))

;;; Key bind
(define-key global-map (kbd "C-x C-t") 'mtk/darwin-open-terminal)
(define-key global-map (kbd "s-E") 'mtk/darwin-open-tweetbot)
