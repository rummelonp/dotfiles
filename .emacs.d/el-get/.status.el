((anything status "installed" recipe
           (:name anything :website "http://www.emacswiki.org/emacs/Anything" :description "Open anything / QuickSilver-like candidate-selection framework" :type git :url "http://repo.or.cz/r/anything-config.git" :shallow nil :load-path
                  ("." "extensions" "contrib")
                  :features anything))
 (auto-complete status "installed" recipe
                (:name auto-complete :website "http://cx4a.org/software/auto-complete/" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
                       (popup fuzzy)))
 (coffee-mode status "installed" recipe
              (:name coffee-mode :website "http://ozmm.org/posts/coffee_mode.html" :description "Emacs Major Mode for CoffeeScript" :type github :pkgname "defunkt/coffee-mode" :features coffee-mode :post-init
                     (progn
                       (add-to-list 'auto-mode-alist
                                    '("\\.coffee$" . coffee-mode))
                       (add-to-list 'auto-mode-alist
                                    '("Cakefile" . coffee-mode))
                       (setq coffee-js-mode 'javascript-mode))))
 (csharp-mode status "installed" recipe
              (:name csharp-mode :website "https://code.google.com/p/csharpmode/" :description "This is a mode for editing C# in emacs. It's based on cc-mode, v5.30.3 and above." :type git-svn :url "http://csharpmode.googlecode.com/svn/trunk/" :features csharp-mode))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :info "." :load "el-get.el"))
 (eldoc-extension status "installed" recipe
                  (:name eldoc-extension :auto-generated t :type emacswiki :description "Some extension for eldoc" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/eldoc-extension.el"))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (js2-mode status "installed" recipe
           (:name js2-mode :website "https://github.com/mooz/js2-mode#readme" :description "An improved JavaScript editing mode" :type github :pkgname "mooz/js2-mode" :prepare
                  (autoload 'js2-mode "js2-mode" nil t)))
 (less-css-mode status "installed" recipe
                (:name less-css-mode :auto-generated t :type elpa :description "Major mode for editing LESS CSS files (lesscss.org) [source: github]"))
 (migemo status "installed" recipe
         (:name migemo :type http :url "https://raw.github.com/gist/457761/migemo.el"))
 (nginx-mode status "installed" recipe
             (:name nginx-mode :website "https://github.com/ajc/nginx-mode" :description "major mode for editing nginx config files" :type github :pkgname "ajc/nginx-mode"))
 (package status "installed" recipe
          (:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin 24 :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
                 (progn
                   (setq package-user-dir
                         (expand-file-name
                          (convert-standard-filename
                           (concat
                            (file-name-as-directory default-directory)
                            "elpa")))
                         package-directory-list
                         (list
                          (file-name-as-directory package-user-dir)
                          "/usr/share/emacs/site-lisp/elpa/"))
                   (make-directory package-user-dir t)
                   (unless
                       (boundp 'package-subdirectory-regexp)
                     (defconst package-subdirectory-regexp "^\\([^.].*\\)-\\([0-9]+\\(?:[.][0-9]+\\)*\\)$" "Regular expression matching the name of\n a package subdirectory. The first subexpression is the package\n name. The second subexpression is the version string."))
                   (setq package-archives
                         '(("ELPA" . "http://tromey.com/elpa/")
                           ("gnu" . "http://elpa.gnu.org/packages/")
                           ("marmalade" . "http://marmalade-repo.org/packages/")
                           ("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
 (point-undo status "installed" recipe
             (:name point-undo :auto-generated t :type emacswiki :description "undo/redo position" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/point-undo.el"))
 (popup status "installed" recipe
        (:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "auto-complete/popup-el"))
 (popwin status "installed" recipe
         (:name popwin :description "Popup Window Manager." :website "https://github.com/m2ym/popwin-el" :type github :pkgname "m2ym/popwin-el"))
 (redo+ status "installed" recipe
        (:name redo+ :auto-generated t :type elpa :description "Redo/undo system for Emacs [source: wiki]"))
 (rinari status "installed" recipe
         (:name rinari :description "Rinari Is Not A Rails IDE" :type github :pkgname "eschulte/rinari" :load-path
                ("." "util" "util/jump")
                :compile
                ("\\.el$" "util")
                :build
                ("rake doc:install_info")
                :info "doc" :features rinari))
 (rsense status "installed" recipe
         (:name rsense :type github :pkgname "m2ym/rsense" :description "RSense client for Emacs" :website "http://cx4a.org/software/rsense/index.html" :load-path
                ("etc")))
 (ruby-end status "installed" recipe
           (:name ruby-end :description "Emacs minor mode for automatic insertion of end blocks for Ruby" :type http :url "https://github.com/rejeep/ruby-end/raw/master/ruby-end.el" :features ruby-end))
 (ruby-mode status "installed" recipe
            (:name ruby-mode :type http :description "Major mode for editing Ruby files." :url "http://bugs.ruby-lang.org/projects/ruby-trunk/repository/raw/misc/ruby-mode.el"))
 (savekill status "installed" recipe
           (:name savekill :description "Save kill ring to disk" :type emacswiki :features "savekill"))
 (scss-mode status "installed" recipe
            (:name scss-mode :description "Major mode for editing SCSS files(http://sass-lang.com)" :type github :pkgname "antonj/scss-mode" :features scss-mode))
 (tabbar status "installed" recipe
         (:name tabbar :type emacswiki :description "Display a tab bar in the header line" :lazy t :load-path "."))
 (undohist status "installed" recipe
           (:name undohist :type github :pkgname "m2ym/undohist-el" :description "Record and recover undo history" :website "http://d.hatena.ne.jp/m2ym/20090707/1246933894"))
 (yaml-mode status "installed" recipe
            (:name yaml-mode :description "Simple major mode to edit YAML file for emacs" :type github :pkgname "yoshiki/yaml-mode"))
 (zencoding-mode status "installed" recipe
                 (:name zencoding-mode :description "Unfold CSS-selector-like expressions to markup" :type github :pkgname "rooney/zencoding" :features zencoding-mode)))
