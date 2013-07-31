;; Initialize

;; japanese environment
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; theme
(load-theme 'deeper-blue t)

;; font
(set-face-attribute 'default nil
                    :family "Monaco"
                    :height 120)
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Maru Gothic ProN"))
(set-fontset-font "fontset-default"
                  'katakana-jisx0201
                  '("Hiragino Maru Gothic ProN"))

;; window
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode t)
(line-number-mode t)
(column-number-mode t)

;; ignore beep sound
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; emacs client server
(server-start)

;; file
(setq require-final-newline t)
(setq backup-inhibited t)
(setq delete-auto-save-files t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; line
(setq kill-whole-line t)
(setq truncate-lines t)

;; paren
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)

;; tab
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
