;;
;; Completion - Copilot
;;

(add-hook 'prog-mode-hook 'copilot-mode)

(defun mtk/copilot-clear-overlay (_)
  (copilot-clear-overlay))

(with-eval-after-load 'company
  (add-hook 'company-after-completion-hook 'mtk/copilot-clear-overlay))
