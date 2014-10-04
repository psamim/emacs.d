(require-package 'auto-complete)

(require 'auto-complete)
(require 'auto-complete-config)


(setq ac-auto-show-menu t)
(setq ac-auto-start t)
(setq ac-comphist-file (concat dotemacs-cache-directory "ac-comphist.dat"))
(setq ac-quick-help-delay 0.3)
(setq ac-quick-help-height 30)
(setq ac-show-menu-immediately-on-auto-complete t)

(dolist (mode '(vimrc-mode
                enh-ruby-mode
                ;; shell-mode term-mode terminal-mode eshell-mode comint-mode skewer-repl-mode
                html-mode
                ;; c-mode
                stylus-mode))
  (add-to-list 'ac-modes mode))


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

;; Bersam's configs

(require 'yasnippet)
(yas-global-mode 1)

(require-package 'auto-complete-c-headers)

(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include/"))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

(require-package 'auto-complete-clang)
(require 'auto-complete-clang)

;; (setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
(global-auto-complete-mode t)
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.1/../../../../include/c++/4.9.1
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.1/../../../../include/c++/4.9.1/x86_64-unknown-linux-gnu
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.1/../../../../include/c++/4.9.1/backward
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.1/include
/usr/local/include
/usr/lib/gcc/x86_64-unknown-linux-gnu/4.9.1/include-fixed
/usr/include
/usr/include/GL/
"
               )))

;; Bersam's End

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
