;;
;; Extension - Completion
;;

;; vertico
(with-eval-after-load 'vertico
  (bind-keys :map vertico-map
             ("C-v"   . vertico-scroll-up)
             ("C-M-v" . vertico-scroll-down)
             ("M-v"   . vertico-scroll-down)
             ("C-s"   . vertico-next)
             ("C-r"   . vertico-previous)))

;; consult
(with-eval-after-load 'consult
  (require 'orderless))

;; company
(with-eval-after-load 'company
  (bind-keys :map company-active-map
             ("C-M-v" . company-previous-page)
             ("C-s"   . company-filter-candidates)
             ("C-M-s" . company-search-candidates)
             ("C-i"   . company-complete)
             ("C-."   . company-show-location))
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
