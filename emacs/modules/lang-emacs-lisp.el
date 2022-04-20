;;;; language - Emacs lisp

;;; emacs-lisp-mode.el
;; Configuration
(defun find-variable-or-function-at-point ()
  (interactive)
  (let ((vsym (variable-at-point))
        (fsym (function-called-at-point)))
    (cond ((and vsym (not (equal vsym 0)))
           (find-variable-other-window vsym))
          (fsym
           (find-function-other-window fsym)))))
(define-key emacs-lisp-mode-map (kbd "C-.") 'find-variable-or-function-at-point)
