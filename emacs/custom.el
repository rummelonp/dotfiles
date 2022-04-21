(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(all-the-icons-scale-factor 1.0)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-use-migemo t)
 '(backup-inhibited t t)
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(company-require-match 'never)
 '(company-selection-wrap-around t)
 '(company-statistics-mode t)
 '(company-tooltip-align-annotations t)
 '(company-transformers
   '(company-sort-by-statistics company-sort-by-backend-importance))
 '(completion-styles '(orderless))
 '(consult-preview-key nil)
 '(css-indent-offset 2)
 '(cua-enable-cua-keys nil)
 '(cua-mode t)
 '(delete-auto-save-files t)
 '(direnv-always-show-summary nil)
 '(direnv-mode t)
 '(global-anzu-mode t)
 '(global-auto-revert-mode t)
 '(global-company-mode t)
 '(global-git-gutter-mode t)
 '(global-undo-tree-mode t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-strict-missing-semi-warning nil)
 '(kill-ring-max 10000)
 '(kill-whole-line t)
 '(marginalia-mode t)
 '(migemo-command
   (cl-find-if 'executable-find
               '("/opt/homebrew/bin/cmigemo" "/usr/local/bin/cmigemo")))
 '(migemo-dictionary
   (cl-find-if 'file-exists-p
               '("/opt/homebrew/share/migemo/utf-8/migemo-dict" "/usr/local/share/migemo/utf-8/migemo-dict" "/usr/share/cmigemo/utf-8/migemo-dict")))
 '(migemo-regex-dictionary nil)
 '(migemo-user-dictionary nil)
 '(mmm-global-mode 'maybe nil (mmm-mode))
 '(neo-theme 'icons)
 '(plantuml-default-exec-mode 'executable)
 '(plantuml-executable-path
   (cl-find-if 'executable-find
               '("/opt/homebrew/bin/plantuml" "/usr/local/bin/plantuml")))
 '(plantuml-indent-level 2)
 '(plantuml-output-type "svg" t)
 '(popwin-mode t)
 '(powerline-default-separator 'utf-8)
 '(powerline-display-hud nil)
 '(powerline-display-mule-info nil)
 '(recentf-auto-cleanup 'never)
 '(recentf-max-menu-items 100000)
 '(recentf-max-saved-items 100000)
 '(recentf-mode t)
 '(require-final-newline t)
 '(ring-bell-function 'ignore)
 '(ruby-deep-indent-paren nil)
 '(ruby-use-smie nil t)
 '(savehist-mode t)
 '(savekill-max-saved-items 1000)
 '(scss-compile-at-save nil)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(show-paren-style 'mixed)
 '(tab-width 2)
 '(tabbar-mode t nil (tabbar))
 '(tabbar-separator '(1))
 '(truncate-lines t)
 '(typescript-indent-level 2)
 '(undo-tree-auto-save-history nil)
 '(uniquify-ignore-buffers-re "*[^*]+*")
 '(vc-follow-symlinks t)
 '(vertico-count 20)
 '(vertico-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-variable-name-face ((t (:foreground "#87d7ff")))))
