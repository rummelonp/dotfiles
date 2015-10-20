;;;; key bind

;;; darwin modifier
(when darwin-p
  (setq mac-control-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-right-command-modifier 'hyper))

;;; backslash
(define-key global-map (kbd "M-(J\(B") "\\")

;;; helm
(define-key global-map (kbd "C-x C-a") 'helm-recentf)
(define-key global-map (kbd "C-x f") 'helm-find-files)
(define-key global-map (kbd "C-x C-f") 'helm-git-files-or-recentf)
(define-key global-map (kbd "C-x b") 'helm-buffers-list)
(define-key global-map (kbd "C-x C-b") 'helm-buffers-list)
(define-key global-map (kbd "C-x m") 'helm-imenu)
(define-key global-map (kbd "C-x C-m") 'helm-imenu-in-all-buffers)
(define-key global-map (kbd "M-x") 'helm-M-x)
(define-key global-map (kbd "C-x C-y") 'helm-show-kill-ring)

;;; frame
(define-key global-map (kbd "C-z") nil)
;;; window
(define-key global-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key global-map (kbd "C-S-t") 'prev-window)
(define-key global-map (kbd "M-t") 'delete-window)
;; tabbar
(define-key global-map (kbd "C-x j") 'tabbar-sort-tab)
(define-key global-map (kbd "C-x C-n") 'tabbar-forward-tab)
(define-key global-map (kbd "C-x C-p") 'tabbar-backward-tab)
(define-key global-map (kbd "C-x n") 'tabbar-forward-group)
(define-key global-map (kbd "C-x p") 'tabbar-backward-group)

;;; basic
;; server
(define-key global-map (kbd "C-x C-c") 'server-edit)
;; buffer
(define-key global-map (kbd "M-k") 'kill-this-buffer)
;; newline and indent
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-j") 'indent-new-comment-line)
(define-key global-map (kbd "C-i") 'indent-for-tab-command)
(define-key global-map (kbd "M-i") 'delete-indentation)
(define-key global-map (kbd "C-x i") 'indent-region)
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
(define-key global-map (kbd "C-M-v") 'scroll-down)
;; kill
(define-key global-map (kbd "C-w") 'kill-ring-save)
(define-key global-map (kbd "M-w") 'kill-region)
(define-key global-map (kbd "C-y") 'yank)
(define-key global-map (kbd "C-M-y") 'yank-pop)
;; undo
(define-key global-map (kbd "C-_") 'undo)
(define-key global-map (kbd "C-M-_") 'redo)
(define-key global-map (kbd "M-p") 'point-undo)
(define-key global-map (kbd "M-n") 'point-redo)
;; comment
(define-key global-map (kbd "C-;") 'comment-or-uncomment-region)
;; configuration
(define-key global-map (kbd "C-/") 'toggle-truncate-lines)
;; help
(define-key global-map (kbd "M-?") 'help-for-help)

;;; auto complete
(define-key global-map (kbd "C-x C-.") 'auto-complete)

;;; find and replace
;; visual regexp
(define-key global-map (kbd "M-%") 'vr/query-replace)
(define-key global-map (kbd "C-M-%") 'vr/replace)
;; anzu
(define-key global-map (kbd "C-,") 'anzu-query-replace-at-cursor-thing)
(define-key global-map (kbd "C-M-,") 'anzu-query-replace-at-cursor)

;;; editor enhancement
;; multiple cursors
(define-key global-map (kbd "C-M-,") 'mc/mark-all-like-this)
(define-key global-map (kbd "C->") 'mc/mark-next-like-this)
(define-key global-map (kbd "C-<") 'mc/mark-previous-like-this)
;; expand region
(define-key global-map (kbd "C-@") 'er/expand-region)
(define-key global-map (kbd "C-M-@") 'er/contract-region)
