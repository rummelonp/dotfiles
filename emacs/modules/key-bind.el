;;;; Key bind

;;; Darwin modifier
(when darwin-p
  (setq mac-control-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-right-command-modifier 'hyper))

;;; Backslash
(define-key global-map (kbd "M-(J\(B") "\\")

;;; consult.el
(define-key global-map (kbd "C-x C-a") 'consult-project-buffer-or-buffer)
(define-key global-map (kbd "C-x C-f") 'project-find-file)
(define-key global-map (kbd "C-x f")   'find-file)
(define-key global-map (kbd "C-x C-d") 'project-find-dir)
(define-key global-map (kbd "C-x d")   'project-find-dir)
(define-key global-map (kbd "C-x C-b") 'consult-project-buffer)
(define-key global-map (kbd "C-x b")   'consult-buffer)
(define-key global-map (kbd "C-x g")   'consult-git-grep)
(define-key global-map (kbd "C-x C-m") 'consult-imenu)
(define-key global-map (kbd "C-x m")   'consult-imenu-multi)
(define-key global-map (kbd "C-x C-y") 'yank-from-kill-ring)
(define-key global-map (kbd "M-g M-g") 'consult-line)
(define-key global-map (kbd "M-g g")   'consult-line-multi)

;;; Frame
(define-key global-map (kbd "C-z") nil)

;;; Window
(define-key global-map (kbd "C-x `") 'delete-other-windows)
(define-key global-map (kbd "C-t") 'next-window-or-split-horizontally)
(define-key global-map (kbd "C-S-t") 'prev-window)
(define-key global-map (kbd "M-t") 'delete-window)
;; tabbar.el
(define-key global-map (kbd "C-x j") 'tabbar-sort-tab)
(define-key global-map (kbd "C-x C-n") 'tabbar-forward-tab)
(define-key global-map (kbd "C-x C-p") 'tabbar-backward-tab)
(define-key global-map (kbd "C-x n") 'tabbar-forward-group)
(define-key global-map (kbd "C-x p") 'tabbar-backward-group)

;;; Basic
;; Server
(define-key global-map (kbd "C-x C-c") 'server-edit)
;; Buffer
(define-key global-map (kbd "M-k") 'kill-this-buffer)
;; Newline and indent
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-j") 'indent-new-comment-line)
(define-key global-map (kbd "C-i") 'indent-for-tab-command)
(define-key global-map (kbd "M-i") 'delete-indentation)
(define-key global-map (kbd "C-x i") 'indent-region)
;; Cursor
(define-key global-map (kbd "M-a") 'beginning-of-defun)
(define-key global-map (kbd "M-e") 'end-of-defun)
(define-key global-map (kbd "M-f") 'forward-sexp)
(define-key global-map (kbd "M-b") 'backward-sexp)
(define-key global-map (kbd "C-M-a") 'backward-sentence)
(define-key global-map (kbd "C-M-e") 'forward-sentence)
(define-key global-map (kbd "C-M-f") 'forward-word)
(define-key global-map (kbd "C-M-b") 'backward-word)
;; Scroll
(define-key global-map (kbd "C-v") 'scroll-up-command)
(define-key global-map (kbd "C-M-v") 'scroll-down)
;; Kill
(define-key global-map (kbd "C-w") 'kill-ring-save)
(define-key global-map (kbd "M-w") 'kill-region)
(define-key global-map (kbd "C-y") 'yank)
(define-key global-map (kbd "C-M-y") 'yank-pop)
;; Undo
(define-key global-map (kbd "C-_") 'undo)
(define-key global-map (kbd "C-/") 'undo)
(define-key global-map (kbd "C-M-_") 'redo)
(define-key global-map (kbd "C-M-/") 'redo)
;; Comment
(define-key global-map (kbd "C-;") 'comment-or-uncomment-region)
;; Configuration
(define-key global-map (kbd "C--") 'toggle-truncate-lines)
;; Help
(define-key global-map (kbd "M-?") 'help-for-help)

;;; Company
;; company.el
(define-key global-map (kbd "C-x C-.") 'company-complete)

;;; Find and replace
;; visual-regexp.el
(define-key global-map (kbd "M-%") 'vr/query-replace)
(define-key global-map (kbd "C-M-%") 'vr/replace)
;; anzu.el
(define-key global-map (kbd "C-,") 'anzu-query-replace-at-cursor-thing)
(define-key global-map (kbd "C-M-,") 'anzu-query-replace-at-cursor)

;;; Editor enhancement
;; multiple-cursors.el
(define-key global-map (kbd "C->") 'mc/mark-next-like-this)
(define-key global-map (kbd "C-M-<") 'mc/unmark-next-like-this)
(define-key global-map (kbd "C-<") 'mc/mark-previous-like-this)
(define-key global-map (kbd "C-M->") 'mc/unmark-previous-like-this)
(define-key global-map (kbd "M-@") 'mc/mark-all-like-this)
;; expand-region.el
(define-key global-map (kbd "C-@") 'er/expand-region)
(define-key global-map (kbd "C-M-@") 'er/contract-region)
