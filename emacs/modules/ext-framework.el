;;;; Extension - Framework

(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-v") 'vertico-scroll-up)
  (define-key vertico-map (kbd "C-M-v") 'vertico-scroll-down)
  (define-key vertico-map (kbd "M-v") 'vertico-scroll-down)
  (define-key vertico-map (kbd "C-s") 'vertico-next)
  (define-key vertico-map (kbd "C-r") 'vertico-previous))

(require 'consult)
(defun mtk/consult-maybe-project-buffer ()
  (interactive)
  (if (consult--project-root)
      (consult-project-buffer)
    (consult-buffer)))

(require 'orderless)
