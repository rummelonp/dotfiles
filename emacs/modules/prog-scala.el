;;
;; Prog - Scala
;;

(with-eval-after-load 'scala-mode
  (require 'lsp-metals))
(add-hook 'scala-mode-hook #'lsp)
