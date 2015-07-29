;; From https://github.com/KusoIDE/kuso_ruby/blob/master/kuso-ruby.el
;; gem install "rubocop"

(require-package 'enh-ruby-mode)
(require-package 'ruby-electric)
(require-package 'bundler)
(require-package 'rvm)
(require-package 'yaml-mode)

;; Yaml mode configurations
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; Ruby mode configurations
(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("config.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("json.jbuilder$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(add-hook 'ruby-mode-hook (lambda ()
                            (rvm-activate-corresponding-ruby)
                            ;; Disable autopaire
                            ;; (autopair-global-mode -1)
                            ;; (autopair-mode -1)
                            ;; (require 'inf-ruby)
                            (ruby-tools-mode t)
                            (ruby-electric-mode t)
                            ;; Enable flycheck
                            (flycheck-mode t)
                            ;; hs mode
                            (hs-minor-mode t)
                            ;; Hack autocomplete so it treat :symbole and symbole the same way
                            (modify-syntax-entry ?: ".")
                            ))

;; configure hs-minor-mode
(add-to-list 'hs-special-modes-alist
'(ruby-mode
"\\(class\\|def\\|do\\|if\\)" "\\(end\\)" "#"
(lambda (arg) (ruby-end-of-block)) nil))

(provide 'init-ruby)
