(require-package 'company)
(require 'company)

(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 1)
(setq company-show-numbers t)
(setq company-tooltip-limit 20)

(setq company-dabbrev-downcase nil)
(setq company-dabbrev-ignore-case nil)

(set-face-attribute 'company-tooltip nil :background "black" :foreground "gray40")
(set-face-attribute 'company-tooltip-selection nil :inherit 'company-tooltip :background "gray15")
(set-face-attribute 'company-preview nil :background "black")
(set-face-attribute 'company-preview-common nil :inherit 'company-preview :foreground "gray40")
(set-face-attribute 'company-scrollbar-bg nil :inherit 'company-tooltip :background "gray20")
(set-face-attribute 'company-scrollbar-fg nil :background "gray40")

(when (executable-find "tern")
  (after "company-tern-autoloads"
    (add-to-list 'company-backends 'company-tern)))

(setq company-global-modes
      '(not
        eshell-mode comint-mode org-mode erc-mode))

(defadvice company-complete-common (around advice-for-company-complete-common activate)
  (when (null (yas-expand))
    ad-do-it))

;; Bersam's Config
;; cc-mode
(require-package 'cc-mode)
(require 'cc-mode)

(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map (kbd "<tab>") 'company-complete)
(define-key c++-mode-map  (kbd "<tab>") 'company-complete)

(require-package 'company-c-headers)

(add-to-list 'company-backends 'company-c-headers)

;; (global-set-key (kbd "<tab>") 'company-complete)

;; ((nil . ((company-clang-arguments . ("-I/home/<user>/project_root/include1/"
                                     ;; "-I/home/<user>/project_root/include2/")))))

;(require-package 'function-args)
;(require 'function-args)
;(fa-config-default)
;(define-key c-mode-map  [(contrl tab)] 'moo-complete)
;(define-key c++-mode-map  [(control tab)] 'moo-complete)
;(define-key c-mode-map (kbd "M-o")  'fa-show)
;(define-key c++-mode-map (kbd "M-o")  'fa-show)

(require-package 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)

(require-package 'company-anaconda)
(add-to-list 'company-backends 'company-anaconda)

;; Psamim's Config
;; company-mode
(defun my-company-tab ()
  (interactive)
  (when (null (yas-expand))
    (company-select-next)))

(defcustom dotemacs-ycmd-server-path nil
  "The path to the ycmd package."
  :group 'dotemacs)

(when dotemacs-ycmd-server-path
  (setq ycmd-server-command `("python" ,dotemacs-ycmd-server-path))
  (require-package 'ycmd)
  (ycmd-setup)

  (require-package 'company-ycmd)
  (company-ycmd-setup))

(global-company-mode)

(provide 'init-company)
