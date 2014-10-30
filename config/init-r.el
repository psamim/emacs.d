
(require-package 'ess)
(require 'ess-site)

(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))
(add-to-list 'auto-mode-alist '("\\.r$" . R-mode))

(setq-default inferior-R-program-name "R")
(setq ess-use-auto-complete 'script-only)

(provide 'init-r)
