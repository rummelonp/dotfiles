;;
;; Language - Ruby
;;

(add-to-list 'auto-mode-alist '("Brewfile$" . ruby-mode))

(with-eval-after-load 'ruby-mode
  (require 'enh-ruby-mode)
  (require 'rinari)
  (require 'robe)
  (push 'company-robe company-backends)
  (add-hook 'ruby-mode-hook 'enh-ruby-mode)
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (add-hook 'enh-ruby-mode-hook 'rinari-minor-mode)
  (define-key enh-ruby-mode-map (kbd "M-a") 'enh-ruby-beginning-of-defun)
  (define-key enh-ruby-mode-map (kbd "M-e") 'enh-ruby-end-of-defun)
  (define-key enh-ruby-mode-map (kbd "M-f") 'enh-ruby-forward-sexp)
  (define-key enh-ruby-mode-map (kbd "M-b") 'enh-ruby-backward-sexp)
  (define-key enh-ruby-mode-map (kbd "C-M-a") 'enh-ruby-backward-sexp) ;; enh-ruby-beginning-of-defun
  (define-key enh-ruby-mode-map (kbd "C-M-e") 'enh-ruby-forward-sexp)  ;; enh-ruby-end-of-defun
  (define-key enh-ruby-mode-map (kbd "C-M-f") 'forward-word)           ;; enh-ruby-forward-sexp
  (define-key enh-ruby-mode-map (kbd "C-M-b") 'backward-word)          ;; enh-ruby-backward-sexp
  (define-key robe-mode-map (kbd "C-.") 'robe-doc)
  (define-key robe-mode-map (kbd "C-M-.") 'robe-jump)
  (define-key robe-mode-map (kbd "M-.") 'pop-tag-mark))
