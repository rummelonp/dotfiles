;;
;; language - Emacs Lisp
;;

(defun mtk/find-anything-at-point ()
  (interactive)
  (let ((vsym (variable-at-point))
        (fsym (function-called-at-point)))
    (cond ((and vsym (not (equal vsym 0)))
           (find-variable-other-window vsym))
          (fsym
           (find-function-other-window fsym)))))
(define-key emacs-lisp-mode-map (kbd "C-.") 'mtk/find-anything-at-point)

(defun mtk/byte-compile-this-file ()
  (interactive)
  (when (eq major-mode 'emacs-lisp-mode)
    (byte-compile-file buffer-file-name)))
(add-hook 'after-save-hook 'mtk/byte-compile-this-file)

(with-eval-after-load 'flycheck
  (flycheck-package-setup))
