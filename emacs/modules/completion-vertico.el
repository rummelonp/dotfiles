;;
;; Completion - Vetico
;;

(with-eval-after-load 'vertico
  (bind-keys :map vertico-map
             ("C-v"   . vertico-scroll-up)
             ("C-M-v" . vertico-scroll-down)
             ("M-v"   . vertico-scroll-down)
             ("C-s"   . vertico-next)
             ("C-r"   . vertico-previous)
             ("C-."   . embark-act)
             ("C-,"   . embark-export)
             ("C-SPC" . embark-collect)))

;; Consult & Embark
(with-eval-after-load 'consult
  (with-eval-after-load 'embark
    (require 'embark-consult))
  (consult-customize
   consult-recent-file consult-project-buffer consult-buffer
   :preview-key nil))

;; Migemo
(require 'migemo)
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
(bind-key "C-i" 'migemo-isearch-toggle-migemo isearch-mode-map)

;; Orderless
(with-eval-after-load 'orderless
  ;; https://nyoho.jp/diary/?date=20210615
  (defun orderless-migemo (component)
    (let ((pattern (migemo-get-pattern component)))
      (condition-case nil
          (progn (string-match-p pattern "") pattern)
        (invalid-regexp nil))))
  (orderless-define-completion-style orderless-default-style
    (orderless-matching-styles '(orderless-literal
                                 orderless-regexp)))
  (orderless-define-completion-style orderless-migemo-style
    (orderless-matching-styles '(orderless-literal
                                 orderless-regexp
                                 orderless-migemo)))
  (setq completion-category-overrides
        '((buffer (styles orderless-migemo-style))
          (consult-location (styles orderless-migemo-style))
          (consult-multi (styles orderless-migemo-style))
          (command (styles orderless-default-style))
          (file (styles orderless-migemo-style))
          (imenu (styles orderless-migemo-style))
          (org-roam-node (styles orderless-migemo-style))
          (project-file (styles orderless-migemo-style))
          (symbol (styles orderless-default-style))
          (unicode-name (styles orderless-migemo-style))
          (variable (styles orderless-default-style)))))
