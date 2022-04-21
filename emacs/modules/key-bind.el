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
(define-key global-map (kbd "C-x C-a") 'mtk/consult-maybe-project-buffer)
(define-key global-map (kbd "C-x C-f") 'project-find-file)                ;; find-file
(define-key global-map (kbd "C-x f")   'find-file)                        ;; set-fill-column
(define-key global-map (kbd "C-x C-d") 'mtk/neotree-toggle)               ;; list-directory
(define-key global-map (kbd "C-x d")   'project-find-dir)                 ;; dired
(define-key global-map (kbd "C-x C-b") 'consult-project-buffer)           ;; list-buffer
(define-key global-map (kbd "C-x b")   'consult-buffer)                   ;; switch-to-buffer
(define-key global-map (kbd "C-x g")   'consult-git-grep)
(define-key global-map (kbd "C-x C-m") 'consult-imenu)
(define-key global-map (kbd "C-x m")   'consult-imenu-multi)              ;; compose-mail
(define-key global-map (kbd "C-x C-y") 'yank-from-kill-ring)
(define-key global-map (kbd "M-g M-g") 'consult-line)                     ;; goto-line
(define-key global-map (kbd "M-g g")   'consult-line-multi)               ;; goto-line

;;; Frame
(define-key global-map (kbd "C-z") nil) ;; suspend-frame

;;; Window
(define-key global-map (kbd "C-x `") 'delete-other-windows)                  ;; next-error
(define-key global-map (kbd "C-t")   'mtk/next-window-or-split-horizontally) ;; transpose-charas
(define-key global-map (kbd "C-S-t") 'mtk/prev-window)
(define-key global-map (kbd "M-t")   'delete-window)                         ;; transpose-words
;; tabbar.el
(define-key global-map (kbd "C-x j")   'mtk/tabbar-sort-tab)
(define-key global-map (kbd "C-x C-n") 'tabbar-forward-tab)    ;; set-goal-column
(define-key global-map (kbd "C-x C-p") 'tabbar-backward-tab)   ;; mark-page
(define-key global-map (kbd "C-x n")   'tabbar-forward-group)  ;; save-buffers-kill-terminal
(define-key global-map (kbd "C-x p")   'tabbar-backward-group)

;;; Basic
;; Server
(define-key global-map (kbd "C-x C-c") 'server-edit) ;; save-buffers-kill-terminal
;; Buffer
(define-key global-map (kbd "M-k") 'kill-this-buffer) ;; kill-sentence
;; Newline and indent
(define-key global-map (kbd "C-m")   'newline-and-indent)      ;; newline
(define-key global-map (kbd "C-j")   'indent-new-comment-line) ;; electric-newline-and-maybe-indent
(define-key global-map (kbd "C-i")   'indent-for-tab-command)  ;; indent-for-tab-command
(define-key global-map (kbd "M-i")   'delete-indentation)      ;; tab-to-tab-stop
(define-key global-map (kbd "C-x i") 'indent-region)           ;; insert-file
;; Cursor
(define-key global-map (kbd "M-a")   'beginning-of-defun) ;; backward-sentence
(define-key global-map (kbd "M-e")   'end-of-defun)       ;; forward-sentence
(define-key global-map (kbd "M-f")   'forward-sexp)       ;; forward-word
(define-key global-map (kbd "M-b")   'backward-sexp)      ;; backward-word
(define-key global-map (kbd "C-M-a") 'backward-sentence)  ;; beginning-of-defun
(define-key global-map (kbd "C-M-e") 'forward-sentence)   ;; end-of-fun
(define-key global-map (kbd "C-M-f") 'forward-word)       ;; forward-sexp
(define-key global-map (kbd "C-M-b") 'backward-word)      ;; backward-sexp
;; Scroll
(define-key global-map (kbd "C-v")   'scroll-up-command) ;; scroll-up-command
(define-key global-map (kbd "C-M-v") 'scroll-down)       ;; scroll-other-window
;; Kill
(define-key global-map (kbd "C-w") 'kill-ring-save) ;; kill-region
(define-key global-map (kbd "M-w") 'kill-region)    ;; kill-ring-save
(define-key global-map (kbd "C-y") 'yank)           ;; yank
(define-key global-map (kbd "C-M-y") 'yank-pop)
;; Undo
(define-key global-map (kbd "C-_")   'undo) ;; undo
(define-key global-map (kbd "C-/")   'undo) ;; undo
(define-key global-map (kbd "C-M-_") 'redo) ;; undo-redo
(define-key global-map (kbd "C-M-/") 'redo) ;; dabbrev-completion
;; Comment
(define-key global-map (kbd "C-;") 'comment-or-uncomment-region)
;; Configuration
(define-key global-map (kbd "C--") 'toggle-truncate-lines) ;; negative-argument
;; Help
(define-key global-map (kbd "M-?") 'help-for-help) ;; xref-find-references

;;; Company
;; company.el
(define-key global-map (kbd "C-x C-.") 'company-complete)

;;; Find and replace
;; visual-regexp.el
(define-key global-map (kbd "M-%")   'vr/query-replace) ;; query-replace
(define-key global-map (kbd "C-M-%") 'vr/replace)       ;; query-replace-regexp
;; anzu.el
(define-key global-map (kbd "C-,")   'anzu-query-replace-at-cursor-thing)
(define-key global-map (kbd "C-M-,") 'anzu-query-replace-at-cursor)

;;; Editor enhancement
;; multiple-cursors.el
(define-key global-map (kbd "C->")   'mc/mark-next-like-this)
(define-key global-map (kbd "C-M-<") 'mc/unmark-next-like-this)
(define-key global-map (kbd "C-<")   'mc/mark-previous-like-this)
(define-key global-map (kbd "C-M->") 'mc/unmark-previous-like-this)
(define-key global-map (kbd "M-@")   'mc/mark-all-like-this)        ;; mark-word
;; expand-region.el
(define-key global-map (kbd "C-@")   'er/expand-region)   ;; set-mark-command
(define-key global-map (kbd "C-M-@") 'er/contract-region) ;; mark-sexp
