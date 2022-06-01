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
;; Core - UI
(straight-use-package '(emacs-kabukicho-theme :type git :host github :repo "mitukiii/emacs-kabukicho-theme"))
(straight-use-package 'all-the-icons)
(straight-use-package 'rainbow-mode)
(straight-use-package 'rainbow-delimiters)
(straight-use-package 'highlight-indent-guides)
;; Core - Key Bindings
(straight-use-package 'bind-key)
(straight-use-package 'which-key)
(straight-use-package 'which-key-posframe)
;; Core - Undo
(straight-use-package 'undohist)
(straight-use-package 'undo-tree)
(straight-use-package 'point-undo)
;; Core - Dired
(straight-use-package 'dired+)
(straight-use-package 'all-the-icons-dired)
;; Core - Tramp
(straight-use-package 'sudo-edit)
;; Core - Editor
(straight-use-package 'recentf-ext)
(straight-use-package 'savekill)
;; Editing
(straight-use-package 'anzu)
(straight-use-package 'multiple-cursors)
(straight-use-package 'expand-region)
(straight-use-package 'string-inflection)
;; Source Control
(straight-use-package 'magit)
(straight-use-package 'magit-delta)
(straight-use-package 'git-gutter)
;; UI - File Tree
(straight-use-package 'treemacs)
(straight-use-package 'treemacs-all-the-icons)
;; UI - Tabs
(straight-use-package 'centaur-tabs)
;; UI - Mode Line
(straight-use-package 'powerline)
(straight-use-package 'nyan-mode)
(straight-use-package 'diminish)
;; UI - Misc
(straight-use-package 'popwin)
;; Completion - Vertico
(straight-use-package 'vertico)
(straight-use-package 'consult)
(straight-use-package 'consult-dir)
(straight-use-package 'embark)
(straight-use-package 'embark-consult)
(straight-use-package 'migemo)
(straight-use-package 'orderless)
(straight-use-package 'marginalia)
(straight-use-package 'all-the-icons-completion)
(straight-use-package 'wgrep)
;; Completion - Company
(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'company-statistics)
(straight-use-package '(company-anywhere :type git :host github :repo "zk-phi/company-anywhere"))
;; Completion - Copilot
(straight-use-package '(copilot :type git :host github :repo "zerolfx/copilot.el" :files ("dist" "*.el")))
;; Checker - Syntax
(straight-use-package 'flycheck)
(straight-use-package 'flycheck-posframe)
(straight-use-package 'consult-flycheck)
;; Tools - LSP
(straight-use-package 'lsp-mode)
(straight-use-package 'lsp-ui)
(straight-use-package 'consult-lsp)
;; Tools - Misc
(straight-use-package 'direnv)
(straight-use-package 'dockerfile-mode)
(straight-use-package 'terraform-mode)
(straight-use-package 'nginx-mode)
;; Lang - Emacs Lisp
(straight-use-package 'elisp-slime-nav)
(straight-use-package 'flycheck-package)
;; Lang - Web
(straight-use-package 'web-mode)
(straight-use-package 'company-web)
(straight-use-package 'emmet-mode)
(straight-use-package 'scss-mode)
(straight-use-package 'typescript-mode)
(straight-use-package 'lsp-javascript-typescript)
(straight-use-package 'json-mode)
;: Lang - Ruby
(straight-use-package 'ruby-mode)
(straight-use-package 'enh-ruby-mode)
(straight-use-package 'robe)
(straight-use-package 'rinari)
(straight-use-package '(auto-fix :type git :host github :repo "tomoya/auto-fix.el"))
(straight-use-package 'rspec-mode)
;; Lang - Rust
(straight-use-package 'rust-mode)
(straight-use-package 'cargo)
;; Lang - Dart
(straight-use-package 'dart-mode)
(straight-use-package 'lsp-dart)
(straight-use-package 'flutter)
;; Lang - Misc
(straight-use-package 'scala-mode)
(straight-use-package 'kotlin-mode)
(straight-use-package 'groovy-mode)
(straight-use-package 'swift-mode)
(straight-use-package 'go-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'markdown-mode)
(straight-use-package 'plantuml-mode)
;; OS - MacOS
(straight-use-package 'osx-osascript)

;;; Load Custom Variables
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;; Variables
(defvar line-primary-fg "black")
(defvar line-primary-bg "#1aa6b1")
(defvar line-light-fg "white")
(defvar line-light-bg "gray40")
(defvar line-dark-fg "white")
(defvar line-dark-bg "grey22")
(defvar line-inactive-fg "gray80")
(defvar line-inactive-bg "#181a26")

(defvar darwin-p
  (eq system-type 'darwin))
(defvar linux-p
  (eq system-type 'gnu/linux))

(defvar module-files
  '(
    core
    core-misc
    source-control
    ui-file-tree
    ui-tabs
    ui-mode-line
    ui-misc
    completion-vertico
    completion-company
    completion-copilot
    checker-syntax
    tools-lsp
    tools-misc
    lang-emacs-lisp
    lang-web
    lang-ruby
    lang-rust
    lang-dart
    lang-misc
    core-functions
    core-key-bindings
    os-macos
    ))

;;; Load Modules
(add-to-list 'load-path "~/.emacs.d/modules")
(defun mtk/try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(cl-dolist (file module-files)
  (let ((file (symbol-name file)))
    (cond
     ((and darwin-p (string-match-p "macos" file))
      (mtk/try-load file))
     ((and linux-p (string-match-p "linux" file))
      (mtk/try-load file))
     (t
      (mtk/try-load file)))))
