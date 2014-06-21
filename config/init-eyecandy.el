(show-paren-mode)
(setq show-paren-delay 0)


(line-number-mode t)
(column-number-mode t)
(display-time-mode t)
(size-indication-mode t)


(defun my-fold-overlay (ov)
  (when (eq 'code (overlay-get ov 'hs))
    (let ((col (save-excursion
                 (move-end-of-line 0)
                 (current-column)))
          (count (count-lines (overlay-start ov) (overlay-end ov))))
      (overlay-put ov 'display
                   (format " %s [ %d lines ] ----"
                           (make-string (- (window-width) col 32) (string-to-char "-"))
                           count)))))
(setq hs-set-up-overlay 'my-fold-overlay)


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


(require-package 'idle-highlight-mode)
(setq idle-highlight-idle-time 0.3)
(add-hook 'prog-mode-hook 'idle-highlight-mode)


(add-hook 'find-file-hook 'hl-line-mode)

;; Samim's confs
(defun psamim-set-window-fonts (&rest frame)
  (if (display-graphic-p)
      (progn
        (set-fontset-font
         "fontset-default"
         (cons (decode-char 'ucs #x0600) (decode-char 'ucs #x06ff)) ; arabic
         ;; "FreeFarsi Monospace-17"))
         "B Traffic-15")
          (set-face-attribute 'default nil :family "Source Code Pro" :height 130)
          ;; (set-face-attribute 'default nil :height 105 :family "Fira Mono")
        (set-transparency 0.9))))

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
