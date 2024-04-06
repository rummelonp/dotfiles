;;
;; Init
;;

(require 'cl-lib)

;;; Packages
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Core - UI
(straight-use-package '(emacs-kabukicho-theme :type git :host github :repo "rummelonp/emacs-kabukicho-theme"))
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
(straight-use-package 'emojify)
(straight-use-package '(gitmoji :type git :host github :repo "janusvm/emacs-gitmoji" :files ("*.el" "data")))
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
(straight-use-package '(copilot :type git :host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el")))
;; Checker - Syntax
(straight-use-package 'flycheck)
(straight-use-package 'flycheck-posframe)
(straight-use-package 'consult-flycheck)
(straight-use-package '(auto-fix :type git :host github :repo "tomoya/auto-fix.el"))
;; Tools - LSP
(straight-use-package 'lsp-mode)
(straight-use-package 'lsp-ui)
(straight-use-package 'consult-lsp)
;; Tools - Misc
(straight-use-package 'direnv)
;; Prog - Emacs Lisp
(straight-use-package 'highlight-quoted)
(straight-use-package 'macrostep)
(straight-use-package 'elisp-slime-nav)
(straight-use-package 'elisp-demos)
(straight-use-package 'flycheck-package)
;; Prog - Web
(straight-use-package 'web-mode)
(straight-use-package 'company-web)
(straight-use-package 'emmet-mode)
;; Prog - CSS
(straight-use-package 'scss-mode)
;; Prog - JavaScript
(straight-use-package 'typescript-mode)
(straight-use-package 'lsp-javascript-typescript)
(straight-use-package 'json-mode)
(straight-use-package '(emacs-prisma-mode :type git :host github :repo "pimeys/emacs-prisma-mode"))
;: Prog - Ruby
(straight-use-package 'ruby-mode)
(straight-use-package 'enh-ruby-mode)
(straight-use-package 'rbs-mode)
(straight-use-package 'robe)
(straight-use-package 'rinari)
(straight-use-package 'rspec-mode)
(straight-use-package 'minitest)
;; Prog - Python
(straight-use-package 'pip-requirements)
;; Prog - Perl
(straight-use-package 'cperl-mode)
(straight-use-package 'cpanfile-mode)
;; Prog - Scala
(straight-use-package 'scala-mode)
(straight-use-package 'lsp-metals)
;; Prog - Dart
(straight-use-package 'dart-mode)
(straight-use-package 'lsp-dart)
(straight-use-package 'flutter)
;; Prog - Rust
(straight-use-package 'rust-mode)
(straight-use-package 'cargo)
;; Prog - Markdown
(straight-use-package 'markdown-mode)
(straight-use-package 'markdown-toc)
(straight-use-package 'grip-mode)
;; Prog - Misc
(straight-use-package 'kotlin-mode)
(straight-use-package 'groovy-mode)
(straight-use-package 'swift-mode)
(straight-use-package 'go-mode)
(straight-use-package 'dockerfile-mode)
(straight-use-package 'terraform-mode)
(straight-use-package 'plantuml-mode)
;; Text - Misc
(straight-use-package 'nginx-mode)
(straight-use-package 'csv-mode)
(straight-use-package 'yaml-mode)
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
    prog-emacs-lisp
    prog-web
    prog-css
    prog-javascript
    prog-ruby
    prog-perl
    prog-scala
    prog-dart
    prog-rust
    prog-markdown
    prog-misc
    text-misc
    core-functions
    core-key-bindings
    os-macos
    ))

;;; Load Modules
(add-to-list 'load-path "~/.emacs.d/modules")
(defun rmp/try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(cl-dolist (file module-files)
  (let ((file (symbol-name file)))
    (cond
     ((and darwin-p (string-match-p "macos" file))
      (rmp/try-load file))
     ((and linux-p (string-match-p "linux" file))
      (rmp/try-load file))
     (t
      (rmp/try-load file)))))
