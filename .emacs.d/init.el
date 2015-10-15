;;;; init

;;; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist
    (package
     '(anzu
       auto-complete
       cl-lib
       coffee-mode
       eldoc-extension
       expand-region
       git-gutter
       helm
       helm-git-files
       js2-mode
       migemo
       mmm-mode
       multiple-cursors
       nginx-mode
       php-mode
       point-undo
       popwin
       powerline
       recentf-ext
       redo+
       rhtml-mode
       savekill
       scss-mode
       tabbar
       undohist
       visual-regexp
       yaml-mode
       yasnippet
       zencoding-mode))
  (unless (package-installed-p package)
    (package-install package)))

;; variables
(defvar darwin-p (eq system-type 'darwin))
(defvar linux-p (eq system-type 'gnu/linux))

;; init.d
(add-to-list 'load-path "~/.emacs.d/init.d")
(let
    ((safe-load
      '(lambda (name)
         (condition-case e
             (load name)
           (error
            (warn (error-message-string e)))))))
  (dolist
      (name
       '("init"
         "extensions"
         "extension-dired"
         "extension-tabbar"
         "extension-powerline"
         "extension-auto-complete"
         "basic-alias"
         "basic-function"
         "basic-keybind"
         "languages"
         "language-ruby"))
    (funcall safe-load name))
  (when darwin-p
    (funcall safe-load "local-osx")))
