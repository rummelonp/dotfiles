;;
;; Prog - Markdown
;;

(add-to-list 'auto-mode-alist '("/TODO\\'" . markdown-mode))

(defun rmp/grip-mode-once ()
  (interactive)
  (if (bound-and-true-p grip-mode)
      (grip-browse-preview)
    (grip-mode +1)))

(with-eval-after-load 'markdown-mode
  (bind-keys :map markdown-mode-map
             ("C-c C-e" . markdown-toc-generate-or-refresh-toc)
             ("C-c C-p" . rmp/grip-mode-once)))
