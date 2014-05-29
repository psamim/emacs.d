(show-paren-mode)
(setq show-paren-delay 0)


(line-number-mode t)
(column-number-mode t)
(display-time-mode t)
(size-indication-mode t)


(require-package 'diminish)
(diminish 'visual-line-mode)
(after 'autopair (diminish 'autopair-mode))
(after 'undo-tree (diminish 'undo-tree-mode))
(after 'auto-complete (diminish 'auto-complete-mode))
(after 'projectile (diminish 'projectile-mode))
(after 'yasnippet (diminish 'yas-minor-mode))
(after 'guide-key (diminish 'guide-key-mode))
(after 'eldoc (diminish 'eldoc-mode))
(after 'smartparens (diminish 'smartparens-mode))
(after 'company (diminish 'company-mode))
(after 'elisp-slime-nav (diminish 'elisp-slime-nav-mode))
(after 'git-gutter+ (diminish 'git-gutter+-mode))
(after 'magit (diminish 'magit-auto-revert-mode))


;; Samim diabled sml
;; (require-package 'smart-mode-line)
;; (setq sml/show-client t)
;; (setq sml/show-eol t)
;; (setq sml/show-frame-identification t)
;; (sml/setup)


(if (fboundp 'global-prettify-symbols-mode)
    (progn
      (global-prettify-symbols-mode)
      (add-hook 'js2-mode-hook
                (lambda ()
                  (push '("function" . 955) prettify-symbols-alist)
                  (push '("return" . 8592) prettify-symbols-alist))))
  (progn
    (require-package 'pretty-symbols)
    (require 'pretty-symbols)
    (diminish 'pretty-symbols-mode)
    (add-to-list 'pretty-symbol-categories 'js)
    (add-to-list 'pretty-symbol-patterns '(955 js "\\<function\\>" (js2-mode)))
    (add-to-list 'pretty-symbol-patterns '(8592 js "\\<return\\>" (js2-mode)))
    (add-hook 'find-file-hook 'pretty-symbols-mode)))


(require-package 'color-identifiers-mode)
(global-color-identifiers-mode)
(diminish 'color-identifiers-mode)


;; (require-package 'fancy-narrow)
;; (fancy-narrow-mode)


(add-hook 'find-file-hook 'hl-line-mode)

;; Samim's confs

(set-face-attribute 'default nil :font
"DejaVu Sans Mono:pixelsize=15:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")

(set-fontset-font
   "fontset-default"
   (cons (decode-char 'ucs #x0600) (decode-char 'ucs #x06ff)) ; arabic
   "Dejavu Sans Mono-13")

(add-hook 'before-make-frame-hook
          #'(lambda ()
              (menu-bar-mode t)
              (font . "source code pro-14")
             ))


(require-package 'solarized-theme)
(load-theme 'solarized-dark)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(secondary-selection ((t (:background "#002B36")))))
(require-package 'writeroom-mode)

(menu-bar-mode -1)

(require 'elscreen)
(elscreen-start)
(elscreen-toggle-display-tab)

(setq frame-title-format
  '("emacs%@" (:eval (system-name)) ": " (:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b")) " [%*]"))

(provide 'init-eyecandy)
