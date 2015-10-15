;;;; extension - framework

;;; helm
(require 'helm-config)
(add-hook 'helm-after-initialize-hook
          '(lambda ()
             ;; key bind
             (define-key helm-map (kbd "C-M-v") 'helm-previous-page)))

;;; helm git files
(require 'helm-git-files)
