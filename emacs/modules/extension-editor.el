;;
;; Extension - Editor
;;

;; migemo
(require 'migemo)
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)

;; flycheck
(with-eval-after-load 'flycheck
  (defun mtk/flycheck-mode-line-status-text (&optional status)
    (let* ((active (powerline-selected-window-active))
           (text (pcase (or status flycheck-last-status-change)
                   (`not-checked "😴")
                   (`no-checker "😎")
                   (`running "🤔")
                   (`errored "😭")
                   (`finished
                    (let-alist (flycheck-count-errors flycheck-current-errors)
                      (if (or .error .warning)
                          (concat (when .error "😰") (when .warning "😥"))
                        "🤩")))
                   (`interrupted "🤯")
                   (`suspicious "🙃"))))
      (concat " " flycheck-mode-line-prefix text)))
  (setq flycheck-mode-line '(:eval (mtk/flycheck-mode-line-status-text))))
