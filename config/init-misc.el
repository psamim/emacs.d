(require-package 'undo-tree)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist
      `(("." . ,(concat dotemacs-cache-directory "undo"))))
(setq undo-tree-visualizer-timestamps t)
(setq undo-tree-visualizer-diff t)
(global-undo-tree-mode)


(require-package 'multiple-cursors)
(after 'evil
  (add-hook 'multiple-cursors-mode-enabled-hook 'evil-emacs-state)
  (add-hook 'multiple-cursors-mode-disabled-hook 'evil-normal-state))


(require-package 'wgrep)


(when (executable-find "pt")
  (require-package 'pt)
  (require-package 'wgrep-pt))


(when (executable-find "ag")
  (require-package 'ag)
  (require 'ag)
  (setq ag-highlight-search t)
  (add-hook 'ag-mode-hook (lambda () (toggle-truncate-lines t)))
  (require-package 'wgrep-ag)
  (add-to-list 'ag-arguments "--silent"))


(when (executable-find "ack")
  (require-package 'ack-and-a-half)
  (require-package 'wgrep-ack))


(require-package 'project-explorer)
(after 'project-explorer
  (setq pe/cache-directory (concat dotemacs-cache-directory "project-explorer"))
  (setq pe/omit-regex (concat pe/omit-regex "\\|^node_modules$")))


(require-package 'ace-jump-mode)


(require-package 'expand-region)


(require-package 'editorconfig)
(require 'editorconfig)


(require-package 'aggressive-indent)
(require 'aggressive-indent)
(add-to-list 'aggressive-indent-excluded-modes 'stylus-mode)
(add-to-list 'aggressive-indent-excluded-modes 'org-mode)
(global-aggressive-indent-mode)


(require-package 'etags-select)
(setq etags-select-go-if-unambiguous t)


(require-package 'windsize)
(require 'windsize)
(setq windsize-cols 16)
(setq windsize-rows 8)
(windsize-default-keybindings)


(require-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


(require-package 'framemove)
(require 'framemove)
(setq framemove-hook-into-windmove t)

;; Samim's confs
(require-package 'elscreen)
(require-package 'org)
(require-package `org-pomodoro)

(require-package 'discover-my-major)


(when (eq system-type 'darwin)
  (require-package 'vkill))

;; Bersam's confs
(add-hook 'prog-mode-hook (lambda ()
                            (local-set-key (kbd "M-RET") 'evil-goto-definition)))
;; bury buffer if successful compile
(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (search-forward "warning" nil t))))
      (run-with-timer 1 nil
                      (lambda (buf)
                        (bury-buffer buf)
                        (delete-window (get-buffer-window buf)))
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

;; make sure $PATH is set correctly
(if (eq system-type 'windows-nt)
    (dolist (path (split-string (getenv "PATH") ";"))
      (add-to-list 'exec-path (replace-regexp-in-string "\\\\" "/" path)))
  (progn
    (require-package 'exec-path-from-shell)
    (exec-path-from-shell-initialize)))

(require-package 'cider)
(require 'cider)
(setq cider-show-error-buffer nil)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq cider-repl-result-prefix ";; => ")
(setq cider-repl-use-clojure-font-lock t)
(add-hook 'cider-repl-mode-hook 'company-mode)
(add-hook 'cider-mode-hook 'company-mode)

(provide 'init-misc)
