;;
;; UI - File tree
;;

(require 'treemacs)

(require 'treemacs-all-the-icons)
(treemacs-load-theme "all-the-icons")

(bind-keys :map treemacs-mode-map
           ("+" . treemacs-create-dir)
           ("F" . treemacs-create-file)
           ("C" . treemacs-copy-file)
           ("D" . treemacs-delete-file)
           ("C-M-n" . treemacs-next-neighbour)
           ("C-M-p" . treemacs-previous-neighbour)
           ("M-n" . treemacs-next-project)
           ("M-p" . treemacs-previous-project))
