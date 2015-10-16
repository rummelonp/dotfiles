;;;; extension - framework

;;; helm
(require 'helm-config)
(helm-mode t)
;; key bind
(define-key helm-map (kbd "C-M-v") 'helm-previous-page)

;;; helm git files
(require 'helm-git-files)

;;; helm descbinds
(require 'helm-descbinds)
(helm-descbinds-mode t)
