;;
;; Prog - Misc
;;

;; Dockerfile
(add-hook 'dockerfile-mode-hook #'lsp)

;; Terraform
(with-eval-after-load 'terraform-mode
  (company-terraform-init)
  (bind-keys :map terraform-mode-map
             ("M-s-l" . terraform-format-buffer)))

;; PlantUML
(add-to-list 'auto-mode-alist '("\\.[pi]uml\\'" . plantuml-mode))

;; Makefile
(defun rmp/setup-makefile-mode ()
  (setq-local indent-tabs-mode t))
(add-hook 'makefile-mode-hook 'rmp/setup-makefile-mode)

;; Shell Script
(add-to-list 'auto-mode-alist '("\\.zshrc.local\\'" . sh-mode))
(add-hook 'sh-mode-hook 'flycheck-posframe-mode)
