;;;; Auto complete

;;; company
(require 'company)
(global-company-mode)
(setq company-require-match 'never
      company-idle-delay 0
      company-minimum-prefix-length 2
      company-selection-wrap-around t
      company-tooltip-align-annotations t)
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
(setq company-transformers
      '(company-sort-by-statistics company-sort-by-backend-importance))
(company-statistics-mode)

;;; company-anywhere
(require 'company-anywhere)
