;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

;; company-anywhere carries no file header and company-statistics rewrites its
;; cache on exit, so neither can hold a lexbind cookie.  Drop this with company.
(require 'warnings)
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))
(add-to-list 'warning-suppress-log-types '(files missing-lexbind-cookie))

(push '(alpha . 95) default-frame-alist)

;; Child frames (posframe, cfrs) inherit default-frame-alist, and a
;; translucent popup shows the code underneath it.
(defun rmp/make-child-frame-opaque (frame)
  (when (frame-parent frame)
    (set-frame-parameter frame 'alpha nil)))
(add-hook 'after-make-frame-functions 'rmp/make-child-frame-opaque)

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
