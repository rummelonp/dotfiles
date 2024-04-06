;;
;; Prog - Dart
;;

(add-hook 'dart-mode-hook #'lsp)
(add-hook 'dart-mode-hook 'flutter-test-mode)

(with-eval-after-load 'dart-mode
  (with-eval-after-load #'lsp-mode
    (bind-keys :map dart-mode-map
               ("C-x C-m" . consult-lsp-file-symbols))))
