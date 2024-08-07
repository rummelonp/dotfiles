;;
;; Prog - Ruby
;;

;; Ruby
(add-to-list 'auto-mode-alist '("\\.irbrc\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Brewfile\\'" . ruby-mode))

(with-eval-after-load 'ruby-mode
  (require 'enh-ruby-mode)
  (add-hook 'ruby-mode-hook 'enh-ruby-mode)
  (add-hook 'enh-ruby-mode-hook 'flycheck-posframe-mode)
  (add-hook 'enh-ruby-mode-hook 'auto-fix-mode)
  (bind-keys :map enh-ruby-mode-map
             ("C-M-f" . forward-word)                ;; enh-ruby-forward-sexp
             ("C-M-b" . backward-word)               ;; enh-ruby-backward-sexp
             ("M-f"   . enh-ruby-forward-sexp)
             ("M-b"   . enh-ruby-backward-sexp)
             ("C-M-a" . enh-ruby-beginning-of-block) ;; enh-ruby-beginning-of-defun
             ("C-M-e" . enh-ruby-end-of-block)       ;; enh-ruby-end-of-defun
             ("M-a"   . enh-ruby-beginning-of-defun)
             ("M-e"   . enh-ruby-end-of-defun))

  (require 'robe)
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (bind-keys :map robe-mode-map
             ("C-."   . robe-doc)
             ("C-M-." . robe-jump))

  (add-hook 'enh-ruby-mode-hook 'rinari-minor-mode))

(defun rmp/setup-ruby-mode ()
  (setq-local company-backends '(company-robe (company-dabbrev-code company-keywords)))
  (setq-local auto-fix-command "rubocop")
  (setq-local auto-fix-option "-A"))
(add-hook 'ruby-mode-hook 'rmp/setup-ruby-mode)

;; RSpec
(with-eval-after-load 'rspec-mode
  (bind-keys :map rspec-mode-map
             ("C-c C-v" . rspec-verify)
             ("C-c C-e" . rspec-verify-single)
             ("C-c C-r" . rspec-rerun)
             ("C-c C-f" . rspec-run-last-failed)))

;; Minitest
(with-eval-after-load 'minitest
  (bind-keys :map minitest-mode-map
             ("C-c C-v" . minitest-verify)
             ("C-c C-e" . minitest-verify-single)
             ("C-c C-r" . minitest-rerun)))
