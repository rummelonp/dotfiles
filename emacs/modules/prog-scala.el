;;
;; Prog - Scala
;;

(add-to-list 'auto-mode-alist '("\\.sc\\'"  . scala-mode))

(with-eval-after-load 'scala-mode
  (require 'lsp-metals))
(add-hook 'scala-mode-hook #'lsp)
