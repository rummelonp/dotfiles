;;
;; Completion - Company
;;

(with-eval-after-load 'company
  (bind-keys :map company-active-map
             ("C-M-v" . company-previous-page)
             ("C-s"   . company-filter-candidates)
             ("C-M-s" . company-search-candidates)
             ("C-i"   . company-complete)
             ("C-."   . company-show-location))
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
