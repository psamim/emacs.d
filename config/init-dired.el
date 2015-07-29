;; Be nicer in dired mode
(define-minor-mode psamim-dired-mode
  "Minor mode over dired-mode."
  :keymap (make-sparse-keymap))

;; Be h j k l
(after 'evil
  (evil-define-key 'normal psamim-dired-mode-map "l" 'dired-find-file)
  (evil-define-key 'normal psamim-dired-mode-map "h" 'dired-up-directory)
  ;; (evil-define-key 'normal psamim-dired-mode-map "n" 'evil-search-next)
  ;; (evil-define-key 'normal psamim-dired-mode-map "N" 'evil-search-previous)
  (evil-define-key 'normal psamim-dired-mode-map "/" 'dired-narrow-fuzzy)
  (evil-define-key 'normal psamim-dired-mode-map "x" 'dired-open-by-extension)
  ;; (evil-define-key 'normal psamim-dired-mode-map "o" 'dired-open-xdg) ;; I don't have xdg
  (evil-define-key 'normal psamim-dired-mode-map "r" 'revert-buffer)
  (evil-define-key 'normal psamim-dired-mode-map "[tab]" 'dired-hide-subdir)
  (evil-define-key 'normal psamim-dired-mode-map "w" 'dired-toggle-read-only)
  (evil-define-key 'normal psamim-dired-mode-map "d" 'dired-details-toggle)
  (evil-define-key 'normal psamim-dired-mode-map "zh" 'dired-omit-mode)
  ;; (evil-define-key 'normal psamim-dired-mode-map "a" 'gnus-dired-attach)

  ;; Go to home
  (evil-define-key 'normal psamim-dired-mode-map "gh" (lambda() (interactive) (find-file "~")))
  (evil-define-key 'normal psamim-dired-mode-map "gm" (lambda() (interactive) (find-file "/media/"))))

(add-hook 'dired-mode-hook
          (lambda()
            (psamim-dired-mode)
            (dired-omit-mode t)
            (hl-line-mode)))

;; ;; Colorize dired
;; (require-package 'dired+)
;; (require 'dired+)

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
                                 ("mp3" . "vlc")
                                 ("mp4" . "vlc")
                                 ("png" . "sxiv")
                                 ("pdf" . "zathura")
                                 ("jpg" . "sxiv")
                                 ("zip" . "file-roller")
                                 ("rar" . "file-roller")
                                 ))))

;; allow dired to be able to delete or copy a whole dir.
(setq dired-recursive-copies (quote always)) ; “always” means no asking
(setq dired-recursive-deletes (quote top)) ; “top” means ask once

;; Show hidden files and switch displaying them
;; http://emacswiki.org/emacs/DiredOmitMode
(require 'dired-x)
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

;; (defvar v-dired-omit t
;;   "If dired-omit-mode enabled by default. Don't setq me.")
;; (setq dired-omit-mode t)
;; (dired-omit-mode t)

;; (defun dired-omit-switch ()
;;   "This function is a small enhancement for `dired-omit-mode', which will
;;    \"remember\" omit state across Dired buffers."
;;   (interactive)
;;   (if (eq v-dired-omit t)
;;       (setq v-dired-omit nil)
;;     (setq v-dired-omit t))
;;   (dired-omit-caller)
;;   (revert-buffer))

;; (defun dired-omit-caller ()
;;   (if v-dired-omit
;;       (setq dired-omit-mode t)
;;     (setq dired-omit-mode nil)))

;; Change dired details
;; (custom-set-variables
;;  '(dired-listing-switches "-Aogh --time-style=+")) ; This is ls options

;; When there are two direds in vertical splits
;; copy/move from one to another
(setq dired-dwim-target t)

;; Ranger configs
;; (require-package 'ranger)
;; (require 'ranger)
;; (setq ranger-show-dotfiles nil)
;; (setq ranger-parent-depth 2)
;; (setq ranger-width-parents 0.28)

(provide 'init-dired)
