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

(defun rmp/project-node-bin (name)
  (let ((bin (concat "node_modules/.bin/" name)))
    (when-let* ((root (locate-dominating-file default-directory bin)))
      (expand-file-name bin root))))

;; Linters start only in projects that install them, so a project gets the
;; linters, versions and rules its own scripts use.  Each server id is also the
;; name of the bin that marks a project as using it.
(defconst rmp/javascript-linters '(eslint biome oxlint))

(defun rmp/setup-typescript-mode ()
  (let* ((dir (rmp/project-typescript-dir))
         (native (and dir (>= (rmp/typescript-major-version dir) 7))))
    (when native
      (setq-local lsp-clients-tsgo-path (expand-file-name "bin/tsc" dir)))
    (setq-local lsp-enabled-clients
                (append (list (if native 'tsgo 'ts-ls) 'astro-ls)
                        (seq-filter (lambda (id)
                                      (rmp/project-node-bin (symbol-name id)))
                                    rmp/javascript-linters))))
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

;; lsp-astro looks for astroserver, a bin no @astrojs/language-server release
;; has shipped (it is astro-ls), and starts the server from PATH only, so the
;; copy lsp-install-server puts in its cache is never found.  The slot is
;; looked up at run time: setf on the accessor would bake lsp-mode's slot
;; order into the .elc, or need lsp-mode loaded at startup to expand.
(with-eval-after-load 'lsp-astro
  (lsp-dependency 'astro-language-server
                  '(:system "astro-ls")
                  '(:npm :package "@astrojs/language-server" :path "astro-ls"))
  (aset (gethash 'astro-ls lsp-clients)
        (cl-struct-slot-offset 'lsp--client 'new-connection)
        (lsp-stdio-connection
         (lambda () (list (lsp-package-path 'astro-language-server) "--stdio")))))

;; lsp-mode ships no client for biome or oxlint; both serve LSP from their CLI.
(with-eval-after-load 'lsp-mode
  (pcase-dolist (`(,id . ,args) '((biome "lsp-proxy") (oxlint "--lsp")))
    (let ((name (symbol-name id)))
      (lsp-register-client
       (make-lsp-client
        :new-connection (lsp-stdio-connection
                         (lambda () (cons (rmp/project-node-bin name) args))
                         (lambda () (rmp/project-node-bin name)))
        :activation-fn (lsp-activate-on "javascript" "javascriptreact"
                                        "typescript" "typescriptreact"
                                        "astro" "vue" "svelte")
        :add-on? t
        :priority -1
        :server-id id)))))

;; JSON
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . jsonc-mode))
(add-to-list 'auto-mode-alist '("\\.json5\\'" . jsonc-mode))

(with-eval-after-load 'json-mode
  (bind-key "M-s-l" 'json-mode-beautify json-mode-map))
