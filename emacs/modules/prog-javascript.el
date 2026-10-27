;;; -*- lexical-binding: t; -*-

;;
;; Prog - JavaScript
;;

;; TypeScript
(define-derived-mode rmp/web-typescript-mode web-mode "Web[TS]")
(add-to-list 'auto-mode-alist '("\\.js\\'"     . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'"     . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'"    . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'"    . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'"    . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . rmp/web-typescript-mode))
(add-to-list 'auto-mode-alist '("\\.astro\\'"  . rmp/web-typescript-mode))

;; TypeScript 7 ships no tsserver, which ts-ls needs, but its tsc serves LSP
;; itself.  Projects on 7+ go through the tsgo client with their own tsc, and
;; the rest keep ts-ls.
(defun rmp/project-typescript-dir ()
  (when-let* ((root (locate-dominating-file
                     default-directory "node_modules/typescript/package.json")))
    (expand-file-name "node_modules/typescript" root)))

(defun rmp/typescript-major-version (dir)
  (with-temp-buffer
    (insert-file-contents (expand-file-name "package.json" dir))
    (string-to-number (gethash "version" (json-parse-buffer)))))

(defun rmp/setup-typescript-mode ()
  (let* ((dir (rmp/project-typescript-dir))
         (native (and dir (>= (rmp/typescript-major-version dir) 7))))
    (when native
      (setq-local lsp-clients-tsgo-path (expand-file-name "bin/tsc" dir)))
    (setq-local lsp-enabled-clients
                (list (if native 'tsgo 'ts-ls) 'astro-ls 'eslint)))
  (lsp)
  (setq-local company-backends '(company-capf)))
(add-hook 'typescript-mode-hook 'rmp/setup-typescript-mode)
(add-hook 'rmp/web-typescript-mode-hook 'rmp/setup-typescript-mode)

;; ts-ls falls back to this copy when a project has no typescript of its own,
;; and only 6 and older still ship tsserver.  lsp-update-server would
;; otherwise move it to 7.
(with-eval-after-load 'lsp-javascript
  (setq lsp-clients-typescript-prefer-use-project-ts-server t)
  (lsp-dependency 'typescript
                  '(:system "tsserver")
                  '(:npm :package "typescript" :path "tsserver" :version "6")))

;; JSON
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . jsonc-mode))
(add-to-list 'auto-mode-alist '("\\.json5\\'" . jsonc-mode))

(with-eval-after-load 'json-mode
  (bind-key "M-s-l" 'json-mode-beautify json-mode-map))
