(when (eq dotemacs-completion-engine 'auto-complete)

  (require-package 'auto-complete)
  (require 'auto-complete)
  (require 'auto-complete-config)

  (setq ac-auto-show-menu t)
  (setq ac-auto-start t)
  (setq ac-comphist-file (concat dotemacs-cache-directory "ac-comphist.dat"))
  (setq ac-quick-help-delay 0.3)
  (setq ac-quick-help-height 30)
  (setq ac-show-menu-immediately-on-auto-complete t)

  (dolist (mode '(vimrc-mode html-mode stylus-mode))
    (add-to-list 'ac-modes mode))

  (ac-config-default)

  (after 'linum
    (ac-linum-workaround))

  (after 'yasnippet
    (add-hook 'yas-before-expand-snippet-hook (lambda () (auto-complete-mode -1)))
    (add-hook 'yas-after-exit-snippet-hook (lambda () (auto-complete-mode t)))
    (defadvice ac-expand (before advice-for-ac-expand activate)
      (when (yas-expand)
        (ac-stop))))

  (require-package 'ac-etags)
  (setq ac-etags-requires 1)
  (after 'etags
    (ac-etags-setup))

  )

;; Samim's configs
(setq ac-disable-faces nil)

 (ac-config-default)
(setq-default ac-sources
    	'(ac-source-filename
          ac-source-files-in-current-dir
        ;ac-etags
        ;ac-source-abbrev
        ac-source-dictionary
        ;ac-source-dabbrev
        ac-source-words-in-buffer
        ac-source-words-in-all-buffer
        ;ac-source-yasnippet
        ac-source-words-in-same-mode-buffers))

; Latex Configs
;(defun my-ac-tex-setup()
 ; (setq ac-sources (append '(
  ;                           ) ac-sources)))
;(add-hook 'LaTeX-mode-hook 'my-ac-tex-setup)

(provide 'init-auto-complete)
