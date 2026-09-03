;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

;; Emacs 31 warns for every dynamically scoped source file.  Keep the
;; existing modules dynamically scoped, but avoid flooding *Warnings* while
;; they are migrated deliberately.
(require 'warnings)
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))
(add-to-list 'warning-suppress-log-types '(files missing-lexbind-cookie))

(custom-set-variables
 '(inhibit-startup-screen t)
 '(inhibit-startup-message t)
 '(initial-scratch-message nil)
 '(initial-frame-alist '((width . 160) (height . 40)))
 '(menu-bar-mode t)
 '(tool-bar-mode nil)
 '(scroll-bar-mode nil)
 '(line-number-mode t)
 '(column-number-mode t))
