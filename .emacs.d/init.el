;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp)))))
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")
(el-get 'sync)

;; variables
(defvar darwin-p (eq system-type 'darwin))
(defvar linux-p (eq system-type 'gnu/linux))

;; init.d
(add-to-list 'load-path "~/.emacs.d/init.d")
(lexical-let
    ((safe-load
      '(lambda (name)
         (condition-case e
             (load name)
           (error
            (warn (error-message-string e)))))))
  (dolist
      (name
       '("basic"
         "basic-alias"
         "basic-function"
         "basic-keybind"
         "extensions"
         "extension-dired"
         "extension-tabbar"
         "extension-auto-complete"
         "languages"
         "language-ruby"))
    (funcall safe-load name))
  (when darwin-p
    (funcall safe-load "local-osx")))
