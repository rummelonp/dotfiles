;;;; Extension - Framework

;;; helm.el
(require 'helm-config)
(helm-mode t)
;; Key bind
(define-key helm-map (kbd "C-M-v") 'helm-previous-page)

;;; helm-git-files.el
(require 'helm-git-files)

;;; helm-descbinds.el
(require 'helm-descbinds)
(helm-descbinds-mode t)
