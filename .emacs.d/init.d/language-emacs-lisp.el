;;;; language - emacs lisp

;;; emacs lisp mode
;; byte complete after save
(add-hook 'after-save-hook
          '(lambda ()
             (when (string-match "\\.el$" buffer-file-name)
               (byte-compile-file buffer-file-name))))

;;; eldoc extension
(require 'eldoc-extension)
;; configuration
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
;; key bind
(define-key emacs-lisp-mode-map (kbd "C-.") 'find-function-at-point)
