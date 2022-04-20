;;;; Auto complete

;;; company
(require 'company)
(global-company-mode)
(define-key company-active-map (kbd "C-M-v") 'company-previous-page)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
(define-key company-active-map (kbd "C-M-s") 'company-search-candidates)
(define-key company-active-map (kbd "C-i") 'company-complete)
(define-key company-active-map (kbd "C-.") 'company-show-location)

;;; company-box
(require 'company-box)
(add-hook 'company-mode-hook 'company-box-mode)

;;; company-statistics
(require 'company-statistics)
(company-statistics-mode)

;;; company-anywhere
(require 'company-anywhere)
