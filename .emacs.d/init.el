;;;; init

;;; variables
(defvar darwin-p
  (eq system-type 'darwin))
(defvar linux-p
  (eq system-type 'gnu/linux))
(defvar required-packages
  '(
    ;; extension - framework
    helm helm-git-files
    ;; exetnsion - basic
    recentf-ext savekill undohist redo+ point-undo
    ;; extension - window
    tabbar powerline popwin git-gutter
    ;; extension - auto complete
    yasnippet auto-complete
    ;; extension - find and replace
    migemo anzu visual-regexp
    ;; extension - editor enhancement
    expand-region multiple-cursors
    ;; language - emacs lisp
    eldoc-extension
    ;; language - conf
    nginx-mode yaml-mode
    ;; language - web
    rhtml-mode zencoding-mode scss-mode coffee-mode js2-mode mmm-mode
    ;; language - other
    php-mode
    ))
(setq required-init-files
  '(
    ;; basics
    "basic"
    ;; extension
    "extension-framework" "extension-basic" "extension-window"
    "extension-auto-complete" "extension-find-and-replace" "extension-editor-enhancement"
    ;; language
    "language-emacs-lisp" "language-conf" "language-web" "language-ruby" "language-php"
    ;; function
    "function"
    ;; key bind
    "key-bind"
    ;; environment dependent
    "darwin-environment"
    ))

;;; install packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package required-packages)
  (unless (package-installed-p package)
    (package-install package)))

;;; load init files
(add-to-list 'load-path "~/.emacs.d/init.d")
(defun try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(dolist (file required-init-files)
  (cond
   ((string-match-p "^darwin" file)
    (when darwin-p
      (try-load file)))
   ((string-match-p "^linux" file)
     (when linux-p
      (try-load file)))
   (t
    (try-load file))))
