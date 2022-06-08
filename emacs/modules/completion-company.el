;;
;; Completion - Company
;;

(with-eval-after-load 'company
  (bind-keys :map company-active-map
             ("C-M-v" . company-previous-page)
             ("C-s"   . company-filter-candidates)
             ("C-M-s" . company-search-candidates)
             ("C-."   . company-show-location)
             ("<tab>" . company-complete)
             ("C-i"   . company-complete))
  (add-hook 'company-mode-hook 'company-box-mode)
  (require 'company-anywhere))
