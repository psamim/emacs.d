(lazy-major-mode "\\.coffee\\'" coffee-mode)
(lazy-major-mode "\\.jade$" jade-mode)


(after "js2-mode-autoloads"
  (require-package 'skewer-mode)
  (skewer-setup))


(require-package 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'stylus-mode-hook 'rainbow-mode)


(defun my-emmet-mode ()
  (require-package 'emmet-mode)
  (emmet-mode))

(add-hook 'css-mode-hook 'my-emmet-mode)
(add-hook 'sgml-mode-hook 'my-emmet-mode)
(add-hook 'web-mode-hook 'my-emmet-mode)


(lazy-major-mode "\\.html?.*$" web-mode)
(lazy-major-mode "\\.php?.*$" php-mode)
(lazy-major-mode "\\.tmpl?.*$" web-mode)


(after 'web-mode
  (after 'yasnippet
    (require-package 'angular-snippets)
    (require 'angular-snippets)
    (angular-snippets-initialize)))

;; indent after deleting a tag
(defadvice sgml-delete-tag (after reindent activate)
  (indent-region (point-min) (point-max)))


;; Samim's confs

;; (require-package 'ac-js2)
;; (add-hook 'js2-mode-hook 'ac-js2-mode)

(require-package 'php-mode)
(require 'php-mode)

(require-package 'php-eldoc)
(add-hook 'php-mode-hook 'php-eldoc-enable)

(defun my-php-mode-hook ()
  (setq indent-tabs-mode t)
  (let ((my-tab-width 4))
    (setq tab-width my-tab-width)
    (setq c-basic-indent my-tab-width)
    (set (make-local-variable 'tab-stop-list)
         (number-sequence my-tab-width 200 my-tab-width))))
(add-hook 'php-mode-hook 'my-php-mode-hook)

;;; Auto-complete CSS keywords
  (dolist (hook '(css-mode-hook sass-mode-hook scss-mode-hook))
    (add-hook hook 'ac-css-mode-setup))

;;; Use eldoc for syntax hints
(require-package 'css-eldoc)
(autoload 'turn-on-css-eldoc "css-eldoc")
(add-hook 'css-mode-hook 'turn-on-css-eldoc)

(defun psamim-web-mode-hook ()
  (setq indent-tabs-mode t)
  (let ((my-tab-width 4))
    (setq tab-width my-tab-width)
    (setq c-basic-indent my-tab-width)
    (setq web-mode-code-indent-offset my-tab-width)
    (set (make-local-variable 'tab-stop-list)
         (number-sequence my-tab-width 200 my-tab-width))))

(add-hook 'web-mode-hook  'psamim-web-mode-hook)

(provide 'init-web)
