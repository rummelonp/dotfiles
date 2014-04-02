;; Ruby

(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rb.sample$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.cap$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Berksfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Bowerfile$" . ruby-mode))
(add-to-list 'ruby-encoding-map '(undecided . utf-8))
(setq ruby-use-smie nil)
(setq ruby-deep-indent-paren nil)
(define-key ruby-mode-map (kbd "C-x C-t") 'macosx-open-terminal)
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

;; function
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

;; ruby block
(add-hook 'ruby-mode-hook
          '(lambda ()
             (require 'ruby-block)
             (ruby-block-mode t)
             (setq ruby-block-highlight-toggle t)))

;; rsense
(add-hook 'ruby-mode-hook
          '(lambda ()
             (require 'rsense)
             (setq rsense-home (expand-file-name "~/.emacs.d/el-get/rsense"))
             (setq rsense-rurema-home (expand-file-name "~/Dropbox/Documents/ruby-refm"))
             (setq rsense-rurema-refe "refe-1_9_3")
             (add-to-list 'ac-sources 'ac-source-rsense-method)
             (add-to-list 'ac-sources 'ac-source-rsense-constant)
             (define-key ruby-mode-map (kbd "C-x .") 'ac-complete-rsense)))

;; rinari
(require 'rinari)
