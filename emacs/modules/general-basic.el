;;;; General - Basic

;;; Environment
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;;; Theme
(load-theme 'dracula t)
(set-frame-parameter nil 'alpha 95)

;;; Faces
;; | 数字 | アルファベット | 日本語 | 絵文字 |
;; | 0123 | abcdefghijklmn | あいう | 🍎🍎🍎 |
(defun mtk/set-font-to-hackgen ()
  (interactive)
  (set-face-attribute 'default nil :family "HackGen" :height 160)
  (setq face-font-rescale-alist '(("Hiragino Maru Gothic ProN" . 1.0)
                                  ("Apple Color Emoji" . 0.8)))
  (set-fontset-font t 'symbol '("Hiragino Maru Gothic ProN"))
  (set-fontset-font t 'symbol '("Apple Color Emoji")))

(defun mtk/set-font-to-monaco ()
  (interactive)
  (set-face-attribute 'default nil :family "Monaco" :height 140)
  (setq face-font-rescale-alist '(("Hiragino Maru Gothic ProN" . 1.2)
                                  ("Apple Color Emoji" . 0.9)))
  (set-fontset-font t 'symbol '("Hiragino Maru Gothic ProN"))
  (set-fontset-font t 'symbol '("Apple Color Emoji")))

(if (find-font (font-spec :name "HackGen"))
    (mtk/set-font-to-hackgen)
  (mtk/set-font-to-monaco))

;;; Server
(require 'server)
(unless (server-running-p)
  (server-start))

;;; Buffer
(require 'savehist)

;;; File
(add-hook 'before-save-hook 'delete-trailing-whitespace)