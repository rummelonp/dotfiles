;;
;; Language - Ruby
;;

(add-to-list 'auto-mode-alist '("\\.irbrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.pryrc$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Brewfile$" . ruby-mode))

(with-eval-after-load 'ruby-mode
  (require 'enh-ruby-mode)
  (require 'rinari)
  (require 'robe)
  (add-hook 'ruby-mode-hook 'enh-ruby-mode)
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (add-hook 'enh-ruby-mode-hook 'rinari-minor-mode)
  (bind-keys :map enh-ruby-mode-map
             ("C-M-f" . forward-word)                ;; enh-ruby-forward-sexp
             ("C-M-b" . backward-word)               ;; enh-ruby-backward-sexp
             ("M-f"   . enh-ruby-forward-sexp)
             ("M-b"   . enh-ruby-backward-sexp)
             ("C-M-a" . enh-ruby-beginning-of-block) ;; enh-ruby-beginning-of-defun
             ("C-M-e" . enh-ruby-end-of-block)       ;; enh-ruby-end-of-defun
             ("M-a"   . enh-ruby-beginning-of-defun)
             ("M-e"   . enh-ruby-end-of-defun))
  (bind-keys :map robe-mode-map
             ("C-."   . robe-doc)
             ("C-M-." . robe-jump)))

(defun mtk/setup-ruby-mode ()
  (setq-local company-backends '(company-robe (company-dabbrev-code company-keywords))))
(add-hook 'ruby-mode-hook 'mtk/setup-ruby-mode)
