;;;; Initialize

;;; Variables
(defvar darwin-p
  (eq system-type 'darwin))
(defvar linux-p
  (eq system-type 'gnu/linux))
(defvar required-packages
  '(
    ;; Basic - Theme
    dracula-theme
    ;; Extension - Framework
    helm helm-ls-git helm-descbinds
    ;; Exetnsion - Basic
    sudo-edit recentf-ext savekill undohist undo-tree rainbow-delimiters
    ;; Extension - Window
    tabbar powerline popwin git-gutter
    ;; Extension - Auto complete
    yasnippet auto-complete
    ;; Extension - Find and replace
    migemo visual-regexp anzu
    ;; Extension - Editor enhancement
    expand-region multiple-cursors
    ;; Language - Config
    nginx-mode yaml-mode markdown-mode
    ;; Language - Web
    rhtml-mode haml-mode slim-mode vue-mode zencoding-mode
    scss-mode less-css-mode
    js2-mode typescript-mode json-mode coffee-mode rjsx-mode
    mmm-mode
    ;; Language - Other
    rinari scala-mode
    ))
(defvar required-init-files
  '(
    ;; Basics
    basic
    ;; Extensions
    ext-framework
    ext-basic
    ext-window
    ext-auto-complete
    ext-find-and-replace
    ext-editor-enhancement
    ;; Languages
    lang-emacs-lisp
    lang-config
    lang-web
    lang-ruby
    ;; Functions
    functions
    ;; Key bind
    key-bind
    ;; Environment dependent
    darwin-environment
    ))

;;; Install packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package required-packages)
  (unless (package-installed-p package)
    (package-install package)))

;;; Load init files
(add-to-list 'load-path "~/.emacs.d/modules")
(defun try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(dolist (file required-init-files)
  (let ((file (symbol-name file)))
    (cond
     ((string-match-p "^darwin" file)
      (when darwin-p
        (try-load file)))
     ((string-match-p "^linux" file)
      (when linux-p
        (try-load file)))
     (t
      (try-load file)))))

(setq custom-file "~/.emacs.d/custom.el")
