;;;; Basic

;;; Environment
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;;; Theme
(load-theme 'deeper-blue t)
(set-frame-parameter nil 'alpha 95)

;;; Faces
(set-face-attribute 'default nil
                    :family "Monaco"
                    :height 120)
(set-fontset-font "fontset-default"
                  'japanese-jisx0208
                  '("Hiragino Maru Gothic ProN"))
(set-fontset-font "fontset-default"
                  'katakana-jisx0201
                  '("Hiragino Maru Gothic ProN"))

;;; Application
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode t)

;;; Window
(line-number-mode t)
(column-number-mode t)

;;; Ignore beep
(setq ring-bell-function 'ignore)

;;; Server
(require 'server)
(unless (server-running-p)
  (server-start))

;;; Buffer
(global-auto-revert-mode 1)

;;; File
(setq require-final-newline t)
(setq backup-inhibited t)
(setq delete-auto-save-files t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Line
(setq kill-whole-line t)
(setq-default truncate-lines t)

;;; Paren
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)

;;; Tab
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
