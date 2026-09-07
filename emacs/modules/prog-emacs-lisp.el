;;
;; Prog - Emacs Lisp
;;

(with-eval-after-load 'elisp-mode
  (add-hook 'emacs-lisp-mode-hook 'flycheck-posframe-mode)
  (add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)

  (bind-keys :map emacs-lisp-mode-map
             ("C-c C-e" . macrostep-expand))

  (require 'elisp-slime-nav)
  (add-hook 'emacs-lisp-mode-hook 'elisp-slime-nav-mode)
  (bind-keys :map elisp-slime-nav-mode-map
             ("C-."   . elisp-slime-nav-describe-elisp-thing-at-point)
             ("C-M-." . elisp-slime-nav-find-elisp-thing-at-point))

  (advice-add 'describe-function-1 :after #'elisp-demos-advice-describe-function-1))

;; Restricted to this configuration's own sources; otherwise saving any
;; third-party elisp drops a .elc next to its source, and straight/ lives
;; inside user-emacs-directory.  early-init is excluded because startup loads
;; it while load-prefer-newer is still nil, so a stale .elc would shadow the
;; source for good.
(defun rmp/byte-compile-this-file ()
  (interactive)
  (let ((dir (file-truename user-emacs-directory))
        (file (and buffer-file-name (file-truename buffer-file-name))))
    (when (and (eq major-mode 'emacs-lisp-mode)
               file
               (file-in-directory-p file dir)
               (not (file-in-directory-p file (expand-file-name "straight" dir)))
               (not (equal file (expand-file-name "early-init.el" dir))))
      (byte-compile-file buffer-file-name))))
(add-hook 'after-save-hook 'rmp/byte-compile-this-file)

(with-eval-after-load 'flycheck
  (flycheck-package-setup))
