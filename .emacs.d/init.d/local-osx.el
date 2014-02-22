;; OSX

;; override
(defun browse-url-default-macosx-browser (url &optional new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (start-process (concat "open" url) nil "open" "--background" url))

;; copy
(defun macosx-copy-current-directory ()
  (interactive)
  (shell-command-to-string "pwd | perl -pe 's/(\r|\n)//' | pbcopy"))

(defun macosx-copy-current-file-path ()
  (interactive)
  (shell-command-to-string (concat "echo " buffer-file-name " | perl -pe 's/(\r|\n)//' | pbcopy")))

(define-key global-map (kbd "C-x C-d") 'macosx-copy-current-directory)
(define-key global-map (kbd "C-x C-p") 'macosx-copy-current-file-path)

;; open
(defun macosx-open-terminal ()
  (interactive)
  (shell-command-to-string "open -a terminal"))

(defun macosx-open-tweetbot ()
  (interactive)
  (shell-command-to-string "open -a tweetbot"))

(define-key global-map (kbd "C-x C-t") 'macosx-open-terminal)
(define-key global-map (kbd "s-E") 'macosx-open-tweetbot)
