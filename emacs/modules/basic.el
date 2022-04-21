;;;; Basic

;;; Environment
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;;; Theme
(setq custom--inhibit-theme-enable nil)
(load-theme 'dracula t)
(custom-set-faces
 '(font-lock-variable-name-face ((t (:foreground "#87d7ff")))))
(set-frame-parameter nil 'alpha 95)

;;; Faces
(if (find-font (font-spec :name "HackGen"))
    (set-face-attribute 'default nil :family "HackGen" :height 160)
  (set-face-attribute 'default nil :family "Monaco" :height 140))
(set-fontset-font "fontset-default" 'japanese-jisx0208 '("Hiragino Maru Gothic ProN"))
(set-fontset-font "fontset-default" 'japanese-jisx0212 '("Hiragino Maru Gothic ProN"))
(set-fontset-font "fontset-default" 'katakana-jisx0201 '("Hiragino Maru Gothic ProN"))
(set-fontset-font "fontset-default" '(#x1F004 . #x1FFFD) '("Apple Color Emoji"))

;;; Ignore beep
(setq ring-bell-function 'ignore)

;;; Server
(require 'server)
(unless (server-running-p)
  (server-start))

;;; VC
(setq vc-follow-symlinks t)

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
