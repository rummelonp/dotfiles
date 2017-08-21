;;;; Language - Ruby

;;; ruby-mode.el
(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Schemafile$" . ruby-mode))
(add-to-list 'ruby-encoding-map '(undecided . utf-8))
;; Configuration
(setq ruby-use-smie nil)
(setq ruby-deep-indent-paren nil)
;; Key bind
(define-key ruby-mode-map (kbd "C-x C-t") 'darwin-open-terminal)
(define-key ruby-mode-map (kbd "C-m") 'reindent-then-newline-and-indent)
(define-key ruby-mode-map (kbd "C-j") 'ruby-end-return)
(define-key ruby-mode-map (kbd "M-a") 'ruby-beginning-of-defun)
(define-key ruby-mode-map (kbd "M-e") 'ruby-end-of-defun)
(define-key ruby-mode-map (kbd "M-f") 'ruby-forward-sexp)
(define-key ruby-mode-map (kbd "M-b") 'ruby-backward-sexp)
(define-key ruby-mode-map (kbd "C-M-a") 'backward-sentence)
(define-key ruby-mode-map (kbd "C-M-e") 'forward-sentence)
(define-key ruby-mode-map (kbd "C-M-f") 'forward-word)
(define-key ruby-mode-map (kbd "C-M-b") 'backward-word)
;; Functions
;; http://stackoverflow.com/questions/7961533/emacs-ruby-method-parameter-indentation
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

(defun ruby-mode-set-encoding ()
  ())

;;; ruby-block.el
(add-hook 'ruby-mode-hook
          '(lambda ()
             (require 'ruby-block)
             (ruby-block-mode t)
             (setq ruby-block-highlight-toggle t)))

;;; rinari.el
(add-hook 'ruby-mode-hook
          '(lambda ()
             (require 'rinari)
             (setq rinari-controller-keywords
                   (append rinari-controller-keywords
                           '("before_action" "append_before_action" "prepend_before_action"
                             "after_action" "append_after_action" "prepend_after_action"
                             "around_action" "append_around_action" "prepend_around_action"
                             "skip_before_action" "skip_after_action" "skip_around_action")))
             (setq rinari-migration-keywords
                   (append rinari-migration-keywords
                           '("set_table_comment" "remove_table_comment"
                             "set_column_comment" "remove_column_comment")))
             (setq rinari-model-keywords
                   (append rinari-model-keywords
                           '("enumerize" "def_delegator")))))
