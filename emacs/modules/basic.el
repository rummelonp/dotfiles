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
;; | 数字 | アルファベット | 日本語 | 絵文字 |
;; | 0123 | abcdefghijklmn | あいう | 🍎🍎🍎 |
(if (find-font (font-spec :name "HackGen"))
    (progn
      (set-face-attribute 'default nil :family "HackGen" :height 160)
      (setq face-font-rescale-alist
            '(("HackGen" . 1.0)
              ("Hiragino Maru Gothic ProN" . 1.0)
              ("Apple Color Emoji" . 0.8))))
  (progn
    (set-face-attribute 'default nil :family "Monaco" :height 140)
    (setq face-font-rescale-alist
            '(("Monaco" . 1.0)
              ("Hiragino Maru Gothic ProN" . 1.2)
              ("Apple Color Emoji" . 0.9)))))
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
