;;;; Extension - Editor

(require 'migemo)
(migemo-init)
(set-process-query-on-exit-flag migemo-process nil)
(define-key isearch-mode-map (kbd "C-i") 'migemo-isearch-toggle-migemo)
