;;
;; UI - Misc
;;

;; Popwin
(with-eval-after-load 'popwin
  (add-to-list 'popwin:special-display-config '("*Backtrace*"   :noselect t))
  (add-to-list 'popwin:special-display-config '("*Warnings*"    :noselect t))
  (add-to-list 'popwin:special-display-config '("*Compile-Log*" :noselect t)))
