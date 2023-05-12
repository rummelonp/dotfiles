;;
;; Completion - Copilot
;;

(add-hook 'prog-mode-hook 'copilot-mode)

(defun rmp/copilot-clear-overlay (_)
  (copilot-clear-overlay))

(with-eval-after-load 'company
  (add-hook 'company-after-completion-hook 'rmp/copilot-clear-overlay))
