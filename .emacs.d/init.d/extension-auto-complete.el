;; Auto Complete

;; yasnippet
(require 'yasnippet)
(yas-global-mode t)

;; prompt
;; http://d.hatena.ne.jp/sugyan/20120111/1326288445
(defun yas/anything-prompt (prompt choices &optional display-fn)
  (let* ((names (loop for choice in choices
                      collect (or (and display-fn (funcall display-fn choice))
                                  coice)))
         (selected (anything-other-buffer
                    `(((name . ,(format "%s" prompt))
                       (candidates . names)
                       (action . (("Insert snippet" . (lambda (arg) arg))))))
                    "*anything yas/prompt*")))
    (if selected
        (let ((n (position selected names :test 'equal)))
          (nth n choices))
      (signal 'quit "user quit!"))))
(add-to-list 'yas-prompt-functions 'yas/anything-prompt)

;; auto complete
(require 'auto-complete-config)
(global-auto-complete-mode t)

;; add yasnippet source
(defun ac-common-setup ()
  (add-to-list 'ac-sources 'ac-source-yasnippet))

;; add major modes
(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'rhtml-mode)
(add-to-list 'ac-modes 'scss-mode)
(add-to-list 'ac-modes 'less-css-mode)
(add-to-list 'ac-modes 'coffee-mode)

;; configuration
(ac-config-default)
(ac-set-trigger-key "C-i")
(setq ac-auto-show-menu 0.5)
(setq ac-quick-help-delay 0.5)

;; menu configuration
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(define-key ac-mode-map (kbd "C-x ?") 'ac-last-quick-help)
