;; Be nicer in dired mode
(define-minor-mode psamim-dired-mode
  "Minor mode over dired-mode."
  :keymap (make-sparse-keymap))

;; Be h j k l
(evil-define-key 'normal psamim-dired-mode-map "l" 'dired-find-file)
(evil-define-key 'normal psamim-dired-mode-map "h" 'dired-up-directory)
(evil-define-key 'normal psamim-dired-mode-map "n" 'evil-search-next)
(evil-define-key 'normal psamim-dired-mode-map "N" 'evil-search-previous)
(evil-define-key 'normal psamim-dired-mode-map "/" 'dired-narrow-fuzzy)
(evil-define-key 'normal psamim-dired-mode-map "o" 'dired-open-by-extension)
;; (evil-define-key 'normal psamim-dired-mode-map "o" 'dired-open-xdg) ;; I don't have xdg
(evil-define-key 'normal psamim-dired-mode-map "r" 'revert-buffer)
(evil-define-key 'normal psamim-dired-mode-map "[tab]" 'dired-hide-subdir)
(evil-define-key 'normal psamim-dired-mode-map "w" 'dired-toggle-read-only)

;; Go to home
(evil-define-key 'normal psamim-dired-mode-map "gh" (lambda() (interactive) (find-file "~")))
(evil-define-key 'normal psamim-dired-mode-map "gm" (lambda() (interactive) (find-file "/media/")))

(add-hook 'dired-mode-hook (lambda() (psamim-dired-mode) (hl-line-mode)))

;; Colorize dired
(require-package 'dired+)
(require 'dired+)

;; Hide owner, group, time and other details
(require-package 'dired-details)
(require 'dired-details)
(dired-details-install)

;; Search dired
(require-package 'dired-narrow)
(require 'dired-narrow)

;; Be a superuser in dired
(require-package 'dired-toggle-sudo)
(require 'dired-toggle-sudo)

;; Open files in external apps
(require-package 'dired-open)
(require 'dired-open)
(custom-set-variables
 '(dired-open-extensions (quote (
                                 ("mp3" . "mplayer")
                                 ("mp4" . "mplayer")
                                 ("png" . "sxiv")
                                 ("pdf" . "zathura")
                                 ("jpg" . "sxiv")
                                 ))))

;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote always)) ; “always” means no asking
(setq dired-recursive-deletes (quote top)) ; “top” means ask once

;; Change dired details
(custom-set-variables
 '(dired-listing-switches "-Aogh --time-style=+")) ; This is ls options

;; When there are two direds in vertical splits
;; copy/move from one to another
(setq dired-dwim-target t)

(provide 'init-dired)
