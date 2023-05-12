;;
;; Lang - Emacs Lisp
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

(defun rmp/setup-emacs-lisp-mode ()
  (setq-local company-backends '(company-elisp)))
(add-hook 'emacs-lisp-mode-hook 'rmp/setup-emacs-lisp-mode)

(defun rmp/byte-compile-this-file ()
  (interactive)
  (when (eq major-mode 'emacs-lisp-mode)
    (byte-compile-file buffer-file-name)))
(add-hook 'after-save-hook 'rmp/byte-compile-this-file)

(with-eval-after-load 'flycheck
  (flycheck-package-setup))
