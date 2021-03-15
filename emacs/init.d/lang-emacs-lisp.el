;;;; language - Emacs lisp

;;; emacs-lisp-mode.el
;; Configuration
(setq edebug-inhibit-emacs-lisp-mode-bindings t)
;; Byte complete after save
(add-hook 'after-save-hook
          '(lambda ()
             (when (string-match "\\.el$" buffer-file-name)
               (byte-compile-file buffer-file-name))))

;;; eldoc-extension.el
(require 'eldoc-extension)
;; Configuration
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
;; Key bind
(define-key emacs-lisp-mode-map (kbd "C-.") 'find-function-at-point)
(define-key emacs-lisp-mode-map (kbd "C-M-.") 'find-function-at-point)
