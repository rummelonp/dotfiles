;;;; Darwin

;;; Functions
;; Copy
(defun darwin-copy-current-directory ()
  (interactive)
  (shell-command-to-string "pwd | perl -pe 's/(\r|\n)//' | pbcopy"))

(defun darwin-copy-current-file-path ()
  (interactive)
  (shell-command-to-string (concat "echo " buffer-file-name " | perl -pe 's/(\r|\n)//' | pbcopy")))

;; Open
(defun darwin-open (name)
  (shell-command-to-string (concat "echo 'tell application \"" name "\" to activate window' | osascript")))

(defun darwin-open-terminal ()
  (interactive)
  (darwin-open "Terminal"))

(defun darwin-open-tweetbot ()
  (interactive)
  (darwin-open "Tweetbot"))

;;; Key bind
(define-key global-map (kbd "C-x C-t") 'darwin-open-terminal)
(define-key global-map (kbd "s-E") 'darwin-open-tweetbot)
