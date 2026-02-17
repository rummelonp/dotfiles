;;
;; Completion - Copilot
;;

(defun rmp/maybe-copilot-mode ()
  (unless (memq major-mode '(typescript-mode rmp/web-typescript-mode))
    (copilot-mode 1)))
(add-hook 'prog-mode-hook 'rmp/maybe-copilot-mode)
