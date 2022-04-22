;;;; Extension - Completion

(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-v") 'vertico-scroll-up)
  (define-key vertico-map (kbd "C-M-v") 'vertico-scroll-down)
  (define-key vertico-map (kbd "M-v") 'vertico-scroll-down)
  (define-key vertico-map (kbd "C-s") 'vertico-next)
  (define-key vertico-map (kbd "C-r") 'vertico-previous))

(with-eval-after-load 'consult
  (require 'orderless))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-M-v") 'company-previous-page)
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)
  (define-key company-active-map (kbd "C-M-s") 'company-search-candidates)
  (define-key company-active-map (kbd "C-i") 'company-complete)
  (define-key company-active-map (kbd "C-.") 'company-show-location)
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
