;;
;; Init
;;

(require 'cl-lib)

;;; Packages
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; General - Basic
(straight-use-package '(emacs-kabukicho-theme :type git :host github :repo "mitukiii/emacs-kabukicho-theme"))
;; Exetnsion - Basic
(straight-use-package 'all-the-icons)
(straight-use-package 'bind-key)
(straight-use-package 'which-key)
(straight-use-package 'recentf-ext)
(straight-use-package 'savekill)
(straight-use-package 'undohist)
(straight-use-package 'undo-tree)
(straight-use-package 'point-undo)
(straight-use-package 'rainbow-mode)
(straight-use-package 'rainbow-delimiters)
(straight-use-package 'direnv)
(straight-use-package 'sudo-edit)
(straight-use-package 'git-gutter)
;; Extension - Window
(straight-use-package 'neotree)
(straight-use-package 'tabbar)
(straight-use-package 'powerline)
(straight-use-package 'popwin)
(straight-use-package 'diminish)
;; Extension - Completion
(straight-use-package 'vertico)
(straight-use-package 'consult)
(straight-use-package 'migemo)
(straight-use-package 'orderless)
(straight-use-package 'marginalia)
(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'company-statistics)
(straight-use-package '(company-anywhere :type git :host github :repo "zk-phi/company-anywhere"))
;; Extension - Editor
(straight-use-package 'expand-region)
(straight-use-package 'multiple-cursors)
(straight-use-package 'anzu)
(straight-use-package 'string-inflection)
;; Language - General
(straight-use-package 'flycheck)
(straight-use-package 'consult-flycheck)
;; Language - Emacs Lisp
(straight-use-package 'elisp-slime-nav)
(straight-use-package 'flycheck-package)
;; Language - Web
(straight-use-package 'web-mode)
(straight-use-package 'company-web)
(straight-use-package 'scss-mode)
(straight-use-package 'js2-mode)
(straight-use-package 'typescript-mode)
(straight-use-package 'json-mode)
;: Language - Ruby
(straight-use-package 'ruby-mode)
(straight-use-package 'enh-ruby-mode)
(straight-use-package 'robe)
(straight-use-package 'rinari)
;; Language - Misc
(straight-use-package 'scala-mode)
(straight-use-package 'kotlin-mode)
(straight-use-package 'groovy-mode)
(straight-use-package 'swift-mode)
(straight-use-package 'go-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'dockerfile-mode)
(straight-use-package 'terraform-mode)
(straight-use-package 'markdown-mode)
(straight-use-package 'plantuml-mode)
(straight-use-package 'nginx-mode)
;; Environment - Darwin
(straight-use-package 'osx-osascript)

;;; Load custom variables
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;; Variables
(defvar darwin-p
  (eq system-type 'darwin))
(defvar linux-p
  (eq system-type 'gnu/linux))
(defvar module-files
  '(
    general-basic
    extension-basic
    extension-window
    extension-completion
    language-general
    language-emacs-lisp
    language-web
    language-ruby
    language-misc
    general-functions
    general-key-bindings
    environment-darwin
    ))

;;; Load modules
(add-to-list 'load-path "~/.emacs.d/modules")
(defun mtk/try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(cl-dolist (file module-files)
  (let ((file (symbol-name file)))
    (cond
     ((and darwin-p (string-match-p "darwin" file))
      (mtk/try-load file))
     ((and linux-p (string-match-p "linux" file))
      (mtk/try-load file))
     (t
      (mtk/try-load file)))))
