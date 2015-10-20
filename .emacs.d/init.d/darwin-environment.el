;;;; darwin

;;; function
;; copy
(defun darwin-copy-current-directory ()
  (interactive)
  (shell-command-to-string "pwd | perl -pe 's/(\r|\n)//' | pbcopy"))

(defun darwin-copy-current-file-path ()
  (interactive)
  (shell-command-to-string (concat "echo " buffer-file-name " | perl -pe 's/(\r|\n)//' | pbcopy")))

;; open
(defun darwin-open-terminal ()
  (interactive)
  (shell-command-to-string "open -a terminal"))

(defun darwin-open-tweetbot ()
  (interactive)
  (shell-command-to-string "open -a tweetbot"))

;;; key bind
(define-key global-map (kbd "C-x C-t") 'darwin-open-terminal)
(define-key global-map (kbd "s-E") 'darwin-open-tweetbot)
