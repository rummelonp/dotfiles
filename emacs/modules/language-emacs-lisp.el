;;
;; language - Emacs Lisp
;;

(defun mtk/setup-emacs-lisp-mode ()
  (require 'elisp-slime-nav)
  (elisp-slime-nav-mode)
  (bind-keys* :map elisp-slime-nav-mode-map
              ("C-."   . elisp-slime-nav-describe-elisp-thing-at-point)
              ("C-M-." . elisp-slime-nav-find-elisp-thing-at-point)))
(add-hook 'emacs-lisp-mode-hook 'mtk/setup-emacs-lisp-mode)

(defun mtk/byte-compile-this-file ()
  (interactive)
  (when (eq major-mode 'emacs-lisp-mode)
    (byte-compile-file buffer-file-name)))
(add-hook 'after-save-hook 'mtk/byte-compile-this-file)

(with-eval-after-load 'flycheck
  (flycheck-package-setup))
