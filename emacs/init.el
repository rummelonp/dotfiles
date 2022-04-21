;;;; Initialize
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

;; Basic - Theme
(straight-use-package 'dracula-theme)
;; Extension - Framework
(straight-use-package 'vertico)
(straight-use-package 'consult)
(straight-use-package 'orderless)
(straight-use-package 'marginalia)
;; Exetnsion - Basic
(straight-use-package 'direnv)
(straight-use-package 'sudo-edit)
(straight-use-package 'recentf-ext)
(straight-use-package 'savekill)
(straight-use-package 'undohist)
(straight-use-package 'undo-tree)
(straight-use-package 'rainbow-mode)
(straight-use-package 'rainbow-delimiters)
;; Extension - Window
(straight-use-package 'all-the-icons)
(straight-use-package 'neotree)
(straight-use-package 'tabbar)
(straight-use-package 'powerline)
(straight-use-package 'popwin)
(straight-use-package 'git-gutter)
;; Extension - Auto complete
(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'company-statistics)
(straight-use-package '(company-anywhere :type git :host github :repo "zk-phi/company-anywhere"))
;; Extension - Find and replace
(straight-use-package 'migemo)
(straight-use-package 'visual-regexp)
(straight-use-package 'anzu)
;; Extension - Other
(straight-use-package 'osx-osascript)
;; Extension - Editor enhancement
(straight-use-package 'expand-region)
(straight-use-package 'multiple-cursors)
;; Language - Config
(straight-use-package 'nginx-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'markdown-mode)
(straight-use-package 'plantuml-mode)
;; Language - Web
(straight-use-package 'rhtml-mode)
(straight-use-package 'vue-mode)
(straight-use-package 'scss-mode)
(straight-use-package 'js2-mode)
(straight-use-package 'typescript-mode)
(straight-use-package 'json-mode)
(straight-use-package 'rjsx-mode)
(straight-use-package 'mmm-mode)
;; Language - Other
(straight-use-package 'rinari)
(straight-use-package 'scala-mode)

(require 'cl-lib)

;;; Variables
(defvar darwin-p
  (eq system-type 'darwin))
(defvar linux-p
  (eq system-type 'gnu/linux))

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

;;; Load init files
(add-to-list 'load-path "~/.emacs.d/modules")
(defun mtk/try-load (file)
  (condition-case e
      (load file)
    (error
     (warn (format "%s: %s" file (error-message-string e))))))
(dolist (file required-init-files)
  (let ((file (symbol-name file)))
    (cond
     ((string-match-p "^darwin" file)
      (when darwin-p
        (mtk/try-load file)))
     ((string-match-p "^linux" file)
      (when linux-p
        (mtk/try-load file)))
     (t
      (mtk/try-load file)))))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
