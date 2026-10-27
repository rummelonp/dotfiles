;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

;; company-anywhere carries no file header and company-statistics rewrites its
;; cache on exit, so neither can hold a lexbind cookie.  Drop this with company.
(require 'warnings)
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))
(add-to-list 'warning-suppress-log-types '(files missing-lexbind-cookie))

;; The bundled libgccjit derives -mmacosx-version-min from the Darwin kernel
;; version with the pre-macOS-26 numbering (Darwin 27 -> 18.0), which clang
;; rejects, so every native compilation fails.  Pass the real version instead.
;; Set it here, not after comp loads: JIT workers are spawned from comp-run,
;; which never loads comp, and inherit only variables bound in this process.
;; "-Wl,-w" repeats the darwin default that this setq replaces.
(defvar native-comp-driver-options)
(when (eq system-type 'darwin)
  (let ((major (car (split-string
                     (car (process-lines "sw_vers" "-productVersion"))
                     "\\."))))
    (setq native-comp-driver-options
          (list "-Wl,-w" (format "-mmacosx-version-min=%s.0" major)))))

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
