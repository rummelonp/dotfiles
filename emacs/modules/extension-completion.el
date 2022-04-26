;;
;; Extension - Completion
;;

;; vertico
(with-eval-after-load 'vertico
  (bind-keys :map vertico-map
             ("C-v"   . vertico-scroll-up)
             ("C-M-v" . vertico-scroll-down)
             ("M-v"   . vertico-scroll-down)
             ("C-s"   . vertico-next)
             ("C-r"   . vertico-previous)))

;; consult
(with-eval-after-load 'consult
  (consult-customize
   consult-recent-file consult-project-buffer consult-buffer
   :preview-key nil))

;; orderless
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
        '((command (styles orderless-default-style))
          (file (styles orderless-migemo-style))
          (buffer (styles orderless-migemo-style))
          (symbol (styles orderless-default-style))
          (consult-location (styles orderless-migemo-style))
          (consult-multi (styles orderless-migemo-style))
          (org-roam-node (styles orderless-migemo-style))
          (unicode-name (styles orderless-migemo-style))
          (variable (styles orderless-default-style)))))

;; company
(with-eval-after-load 'company
  (bind-keys :map company-active-map
             ("C-M-v" . company-previous-page)
             ("C-s"   . company-filter-candidates)
             ("C-M-s" . company-search-candidates)
             ("C-i"   . company-complete)
             ("C-."   . company-show-location))
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
