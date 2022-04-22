;;;; language - Emacs Lisp

;;; emacs-lisp-mode.el
;; Configuration
(defun mtk/find-anything-at-point ()
  (interactive)
  (let ((vsym (variable-at-point))
        (fsym (function-called-at-point)))
    (cond ((and vsym (not (equal vsym 0)))
           (find-variable-other-window vsym))
          (fsym
           (find-function-other-window fsym)))))
(define-key emacs-lisp-mode-map (kbd "C-.") 'mtk/find-anything-at-point)
