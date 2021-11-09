;;;; language - Emacs lisp

;;; emacs-lisp-mode.el
;; Configuration
(setq edebug-inhibit-emacs-lisp-mode-bindings t)
;; Byte complete after save
(add-hook 'after-save-hook
          '(lambda ()
             (when (string-match "\\.el$" buffer-file-name)
               (byte-compile-file buffer-file-name))))
