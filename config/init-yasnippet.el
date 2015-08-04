;; (delayed-init
(require-package 'yasnippet)

;; (let* ((yas-install-dir (car (file-expand-wildcards (concat package-user-dir "/yasnippet-*"))))
;;        (dir (concat yas-install-dir "/snippets/js-mode")))
;;   (if (file-exists-p dir)
;;       (delete-directory dir t)))

(require 'yasnippet)

(setq yas-fallback-behavior 'return-nil)
(setq yas-also-auto-indent-first-line t)
(setq yas-prompt-functions '(yas/ido-prompt yas/completing-prompt))
(yas-global-mode 1)
;; (add-hook 'prog-mode-hook 'yas-minor-mode)
;; (add-hook 'html-mode-hook 'yas-minor-mode)
;; (add-hook 'org-mode-hook 'yas-minor-mode)

(yas-load-directory (concat user-emacs-directory "/snippets"))
;; (setq yas-snippet-dirs
;;       '(concat user-emacs-directory "/snippets"))

(add-hook 'web-mode-hook
          #'(lambda ()
              (yas-activate-extra-mode 'php-mode)))

(provide 'init-yasnippet)
