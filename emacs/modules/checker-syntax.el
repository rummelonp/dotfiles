;;
;; Checker - Syntax
;;

;; Flycheck
(with-eval-after-load 'flycheck
  (defun rmp/flycheck-mode-line-status-text (&optional status)
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
  (setq flycheck-mode-line '(:eval (rmp/flycheck-mode-line-status-text))))

;; Auto Fix
(defvar auto-fix-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-s-l") 'auto-fix)
    map)
  "Keymap for `auto-fix-mode'.")
(require 'auto-fix)
