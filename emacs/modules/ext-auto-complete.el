;;;; Auto complete

;;; company
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-M-v") 'company-previous-page)
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)
  (define-key company-active-map (kbd "C-M-s") 'company-search-candidates)
  (define-key company-active-map (kbd "C-i") 'company-complete)
  (define-key company-active-map (kbd "C-.") 'company-show-location)
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
