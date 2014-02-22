;; Keybind

;; mac key
(when darwin-p
  (setq mac-control-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-right-command-modifier 'hyper))


;; key map
(define-prefix-command 'screen-map)
(define-key global-map (kbd "C-z") 'screen-map)

;; backslash
(define-key global-map (kbd "M-(J\(B") "\\")

;; newline and indent
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "M-m") 'back-to-indentation)
(define-key global-map (kbd "C-j") 'indent-new-comment-line)
(define-key global-map (kbd "M-j") 'indent-new-comment-line)
(define-key global-map (kbd "C-i") 'indent-for-tab-command)
(define-key global-map (kbd "M-i") 'delete-indentation)
(define-key global-map (kbd "C-x i") 'indent-region)
(define-key global-map (kbd "C-x C-i") 'indent-and-untabify-buffer)

;; truncate line
(define-key global-map (kbd "C-/") 'toggle-truncate-lines)

;; cursor
(define-key global-map (kbd "M-a") 'beginning-of-defun)
(define-key global-map (kbd "M-e") 'end-of-defun)
(define-key global-map (kbd "M-f") 'forward-sexp)
(define-key global-map (kbd "M-b") 'backward-sexp)
(define-key global-map (kbd "C-M-a") 'backward-sentence)
(define-key global-map (kbd "C-M-e") 'forward-sentence)
(define-key global-map (kbd "C-M-f") 'forward-word)
(define-key global-map (kbd "C-M-b") 'backward-word)

;; scroll
(define-key global-map (kbd "C-v") 'scroll-up-command)
(define-key global-map (kbd "M-v") 'scroll-other-window)
(define-key global-map (kbd "C-M-v") 'scroll-down)

;; kill
(define-key global-map (kbd "C-w") 'kill-ring-save)
(define-key global-map (kbd "M-w") 'kill-region)
(define-key global-map (kbd "C-y") 'yank)
(define-key global-map (kbd "M-y") 'yank-pop)
(define-key global-map (kbd "C-M-y") 'yank-pop)

;; window
(define-key global-map (kbd "C-x 1") 'delete-other-windows)
(define-key global-map (kbd "C-z 1") 'delete-other-windows)
(define-key global-map (kbd "C-2") 'split-window-vertically)
(define-key global-map (kbd "C-x 2") 'split-window-vertically)
(define-key global-map (kbd "C-z 2") 'split-window-vertically)
(define-key global-map (kbd "C-3") 'split-window-horizontally)
(define-key global-map (kbd "C-x 3") 'split-window-horizontally)
(define-key global-map (kbd "C-z 3") 'split-window-horizontally)
(define-key global-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key global-map (kbd "C-M-t") 'next-window-or-split-vertically)
(define-key global-map (kbd "C-S-t") 'prev-window-or-split-horizontally)
(define-key global-map (kbd "C-x t") 'delete-window)
(define-key global-map (kbd "M-t") 'delete-window)
(define-key global-map (kbd "C-^") 'enlarge-window)
(define-key global-map (kbd "C-~") 'enlarge-window-horizontally)
(define-key global-map (kbd "C-M-^") 'shrink-window)
(define-key global-map (kbd "C-M-~") 'shrink-window-horizontally)
(define-key global-map (kbd "C-s-<up>") 'windmove-up)
(define-key global-map (kbd "C-s-<left>") 'windmove-left)
(define-key global-map (kbd "C-s-<right>") 'windmove-right)
(define-key global-map (kbd "C-s-<down>") 'windmove-down)

;; buffer
(define-key global-map (kbd "M-k") 'kill-this-buffer)

;; server
(define-key global-map (kbd "C-x C-c") 'server-edit)

;; comment
(define-key global-map (kbd "C-;") 'comment-or-uncomment-region)

;; help
(define-key global-map (kbd "M-?") 'help-for-help)
(define-key global-map (kbd "C-x k") 'describe-key)

;; undo redo
(define-key global-map (kbd "C-_") 'undo)
(define-key global-map (kbd "M-_") 'redo)
(define-key global-map (kbd "C-M-_") 'redo)
(define-key global-map (kbd "M-p") 'point-undo)
(define-key global-map (kbd "M-n") 'point-redo)

;; replace
(define-key global-map (kbd "M-#") 'anzu-query-replace)
(define-key global-map (kbd "C-M-#") 'replace-string)
(define-key global-map (kbd "M-$") 'anzu-query-replace-regexp)
(define-key global-map (kbd "C-M-$") 'replace-regexp)
(define-key global-map (kbd "M-%") 'vr/query-replace)
(define-key global-map (kbd "C-M-%") 'vr/replace)
(define-key global-map (kbd "C-,") 'anzu-query-replace-at-cursor-thing)

;; anything
(define-key global-map (kbd "C-.") 'anything-yaetags-find-tag)
(define-key global-map (kbd "C-x C-a") 'anything-recentf)
(define-key global-map (kbd "C-x f") 'anything-find-file)
(define-key global-map (kbd "C-x C-f") 'anything-git-files-or-recentf)
(define-key global-map (kbd "C-x b") 'anything-buffers+)
(define-key global-map (kbd "C-x C-b") 'anything-buffers+)
(define-key global-map (kbd "C-x C-x") 'anything-execute-anything-command)
(define-key global-map (kbd "M-x") 'anything-execute-extended-command)
(define-key global-map (kbd "C-x C-y") 'anything-show-kill-ring)

;; dash-at-point
(define-key global-map (kbd "M-.") 'dash-at-point)

;; tabbar
(define-key global-map (kbd "C-z a") 'tabbar-local-mode)
(define-key global-map (kbd "C-z C-s") 'tabbar-sort-tab)
(define-key global-map (kbd "C-z k") 'kill-this-buffer)
(define-key global-map (kbd "C-z C-n") 'tabbar-forward-tab)
(define-key global-map (kbd "C-<tab>") 'tabbar-forward-tab)
(define-key global-map (kbd "s-]") 'tabbar-forward-tab)
(define-key global-map (kbd "C-z C-p") 'tabbar-backward-tab)
(define-key global-map (kbd "C-S-<tab>") 'tabbar-backward-tab)
(define-key global-map (kbd "s-[") 'tabbar-backward-tab)
(define-key global-map (kbd "C-z n") 'tabbar-forward-group)
(define-key global-map (kbd "s-}") 'tabbar-forward-group)
(define-key global-map (kbd "C-z p") 'tabbar-backward-group)
(define-key global-map (kbd "s-{") 'tabbar-backward-group)

;; auto complete
(define-key global-map (kbd "C-x .") 'auto-complete)
(define-key global-map (kbd "C-x C-.") 'auto-complete)

;; popwin
(define-key global-map (kbd "C-x p") 'popwin:display-last-buffer)
(define-key global-map (kbd "C-x s") 'popwin:stick-popup-window)

;; jaunte
(define-key global-map (kbd "C-x j") 'jaunte)

;; expand-region
(define-key global-map (kbd "C-@") 'er/expand-region)
(define-key global-map (kbd "C-M-@") 'er/contract-region)

;; multiple-cursors
(define-key global-map (kbd "C-M-,") 'mc/mark-all-like-this)
(define-key global-map (kbd "C->") 'mc/mark-next-like-this)
(define-key global-map (kbd "C-<") 'mc/mark-previous-like-this)

;; highlight-symbol
(define-key global-map (kbd "C-:") 'highlight-symbol-at-point)
(define-key global-map (kbd "C-M-:") 'highlight-symbol-remove-all)
