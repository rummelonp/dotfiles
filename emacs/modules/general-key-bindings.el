;;
;; General - Key bindings
;;

;;; Darwin modifier
(when darwin-p
  (setq mac-control-modifier 'control)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-right-command-modifier 'hyper))

;;; Character
(bind-key "M-(J\(B" "\\")

;;; Completion
;; consult
(bind-key "C-x C-a" 'consult-recent-file)
(bind-key "C-x C-f" 'project-find-file)      ;; find-file
(bind-key "C-x f"   'find-file)              ;; set-fill-column
(bind-key "C-x C-d" 'mtk/neotree-toggle)     ;; list-directory
(bind-key "C-x d"   'project-find-dir)       ;; dired
(bind-key "C-x C-b" 'consult-project-buffer) ;; list-buffer
(bind-key "C-x b"   'consult-buffer)         ;; switch-to-buffer
(bind-key "C-x g"   'consult-git-grep)
(bind-key "C-x C-m" 'consult-imenu)
(bind-key "C-x m"   'consult-imenu-multi)    ;; compose-mail
(bind-key "C-x C-y" 'yank-from-kill-ring)
(bind-key "M-g M-g" 'consult-line)           ;; goto-line
(bind-key "M-g g"   'consult-line-multi)     ;; goto-line
;; company
(bind-key "C-x C-." 'company-complete)

;;; Window
;; frame
(bind-key "C-z" nil) ;; suspend-frame
;; window
(bind-key  "C-x `" 'delete-other-windows)                  ;; next-error
(bind-key* "C-t"   'mtk/next-window-or-split-horizontally) ;; transpose-charas
(bind-key  "C-S-t" 'mtk/prev-window)
(bind-key  "M-t"   'delete-window)                         ;; transpose-words
;; tabbar
(bind-key "C-x j"   'mtk/tabbar-sort-tab)
(bind-key "C-x C-n" 'tabbar-forward-tab)    ;; set-goal-column
(bind-key "C-x C-p" 'tabbar-backward-tab)   ;; mark-page
(bind-key "C-x n"   'tabbar-forward-group)  ;; save-buffers-kill-terminal
(bind-key "C-x p"   'tabbar-backward-group)

;;; Basic
;; server
(bind-key "C-x C-c" 'server-edit) ;; save-buffers-kill-terminal
;; buffer
(bind-key "M-k" 'kill-this-buffer) ;; kill-sentence
;; newline and indent
(bind-key "C-m"   'newline-and-indent)      ;; newline
(bind-key "C-j"   'indent-new-comment-line) ;; electric-newline-and-maybe-indent
(bind-key "C-i"   'indent-for-tab-command)  ;; indent-for-tab-command
(bind-key "M-i"   'delete-indentation)      ;; tab-to-tab-stop
(bind-key "C-x i" 'indent-region)           ;; insert-file
;; cursor
(bind-key "C-M-f" 'forward-word)       ;; forward-sexp
(bind-key "C-M-b" 'backward-word)      ;; backward-sexp
(bind-key "M-f"   'forward-sexp)       ;; forward-word
(bind-key "M-b"   'backward-sexp)      ;; backward-word
(bind-key "C-M-a" 'backward-sentence)  ;; beginning-of-defun
(bind-key "C-M-e" 'forward-sentence)   ;; end-of-fun
(bind-key "M-a"   'beginning-of-defun) ;; backward-sentence
(bind-key "M-e"   'end-of-defun)       ;; forward-sentence
;; scroll
(bind-key "C-v"   'scroll-up-command) ;; scroll-up-command
(bind-key "C-M-v" 'scroll-down)       ;; scroll-other-window
;; kill
(bind-key "C-w" 'kill-ring-save) ;; kill-region
(bind-key "M-w" 'kill-region)    ;; kill-ring-save
(bind-key "C-y" 'yank)           ;; yank
(bind-key "C-M-y" 'yank-pop)
;; undo
(bind-key "C-_"   'undo)           ;; undo
(bind-key "C-/"   'undo)           ;; undo
(bind-key "C-M-_" 'undo-tree-redo) ;; undo-redo
(bind-key "C-M-/" 'undo-tree-redo) ;; dabbrev-completion
;; point undo
(bind-key "M-p" 'point-undo)
(bind-key "M-n" 'point-redo)
;; comment
(bind-key "C-;" 'comment-or-uncomment-region)
;; configuration
(bind-key "C--" 'toggle-truncate-lines) ;; negative-argument
;; help
(bind-key "M-?" 'help-for-help) ;; xref-find-references

;;; Editor
;; expand-region
(bind-key "C-@"   'er/expand-region)   ;; set-mark-command
(bind-key "C-M-@" 'er/contract-region) ;; mark-sexp
;; multiple-cursors
(bind-key "C->"   'mc/mark-next-like-this)
(bind-key "C-M-<" 'mc/unmark-next-like-this)
(bind-key "C-<"   'mc/mark-previous-like-this)
(bind-key "C-M->" 'mc/unmark-previous-like-this)
(bind-key "M-@"   'mc/mark-all-like-this)        ;; mark-word
;; visual-regexp
(bind-key "M-%"   'vr/query-replace) ;; query-replace
(bind-key "C-M-%" 'vr/replace)       ;; query-replace-regexp
;; anzu
(bind-key "C-,"   'anzu-query-replace-at-cursor-thing)
(bind-key "C-M-," 'anzu-query-replace-at-cursor)
