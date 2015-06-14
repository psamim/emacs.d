(defgroup dotemacs nil
  "Custom configuration for dotemacs."
  :group 'local)

(defcustom dotemacs-cache-directory (concat user-emacs-directory ".cache/")
  "The storage location for various persistent files."
  :group 'dotemacs)

(defcustom dotemacs-completion-engine
  'company
  "The completion engine the use."
  :type '(radio
          (const :tag "company-mode" company)
          (const :tag "auto-complete-mode" auto-complete))
  :group 'dotemacs)

(with-current-buffer (get-buffer-create "*Require Times*")
  (insert "| feature | elapsed | timestamp |\n")
  (insert "|---------+---------+-----------|\n"))

(defadvice require (around require-advice activate)
  (let ((elapsed)
        (loaded (memq feature features))
        (start (current-time)))
    (prog1
        ad-do-it
      (unless loaded
        (with-current-buffer (get-buffer-create "*Require Times*")
          (goto-char (point-max))
          (setq elapsed (float-time (time-subtract (current-time) start)))
          (insert (format "| %s | %s | %f |\n"
                          feature
                          (format-time-string "%Y-%m-%d %H:%M:%S.%3N" (current-time))
                          elapsed)))))))

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(unless (display-graphic-p) (menu-bar-mode -1))

(add-to-list 'load-path (concat user-emacs-directory "/config"))
(let ((base (concat user-emacs-directory "/elisp")))
  (add-to-list 'load-path base)
  (dolist (dir (directory-files base t "^[^.]"))
    (when (file-directory-p dir)
      (add-to-list 'load-path dir))))

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-enable-at-startup nil)
(package-initialize)

(require 'init-util)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

<<<<<<< HEAD
(defcustom dotemacs-modules
  '(init-core

    init-eshell
    init-org
    init-erc
    init-eyecandy

    init-yasnippet
    init-completion

    init-projectile
    init-helm
    init-ido

    init-vcs
    init-flycheck

    init-lisp

    init-vim
    init-stylus
    init-js
    init-go
    init-web
    init-markup

    init-smartparens
    init-misc
    init-evil
    init-bindings
    init-macros

    init-overrides

    init-editor
    init-git
    init-flycheck
    ;; init-latex
    ;; init-gnus
    init-ruby
    init-dired
    init-r
    init-sync
    init-mu)

  "Set of modules enabled in dotemacs."
  :group 'dotemacs)

(add-to-list 'after-init-hook
             (lambda ()
               (dolist (module dotemacs-modules)
                 (with-demoted-errors "######## INIT-ERROR ######## %s"
                   (require module)))))
(server-force-delete)
(setq server-socket-dir "/tmp/samim/emacs1000/server")
(server-start)
=======
(eval-when-compile (require 'cl))
(let ((debug-on-error t))
  (cl-loop for file in (directory-files (concat user-emacs-directory "config/"))
           if (not (file-directory-p file))
           do (require (intern (file-name-base file)))))
>>>>>>> 17f5bb292b7177ab5771ae9af90cd90305303d1e
