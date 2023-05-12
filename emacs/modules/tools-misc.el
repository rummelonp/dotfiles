;;
;; Tools - Misc
;;

;; Conf
(require 'generic-x)
(add-to-list 'auto-mode-alist '("\\.aws/credentials\\'" . conf-mode))

;; Makefile
(defun rmp/setup-makefile-mode ()
  (setq-local indent-tabs-mode t))
(add-hook 'makefile-mode-hook 'rmp/setup-makefile-mode)

;; Dockerfile
(add-hook 'dockerfile-mode-hook #'lsp)

;; Terraform
(with-eval-after-load 'terraform-mode
  (bind-keys :map terraform-mode-map
             ("M-s-l" . terraform-format-buffer)))
