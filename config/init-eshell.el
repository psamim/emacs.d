(defgroup dotemacs-eshell nil
  "Configuration options for eshell-mode."
  :group 'dotemacs
  :prefix 'dotemacs-eshell)

(defcustom dotemacs-eshell/plan9
  nil
  "Turns on Plan9 style prompt in eshell when non-nil."
  :group 'dotemacs-eshell)

(defcustom dotemacs-eshell/prompt-git-stats
  t
  "Turns on additional git status statistics in the prompt."
  :group 'dotemacs-eshell
  :type 'boolean)


(setq eshell-directory-name (concat dotemacs-cache-directory "eshell"))
(setq eshell-scroll-to-bottom-on-input 'this)
(setq eshell-buffer-shorthand t)
(setq eshell-aliases-file (concat user-emacs-directory ".eshell-aliases"))
(setq eshell-glob-case-insensitive t)
(setq eshell-error-if-no-glob t)
(setq eshell-history-size 1024)
(setq eshell-cmpl-ignore-case t)
(setq eshell-last-dir-ring 512)
(setq eshell-prompt-function
      (lambda ()
        (concat (propertize (abbreviate-file-name (eshell/pwd)) 'face 'eshell-prompt)
                (when (fboundp #'vc-git-branches)
                  (let ((branch (car (vc-git-branches))))
                    (when branch
                      (concat
                       (propertize " [" 'face 'font-lock-keyword-face)
                       (propertize branch 'face 'font-lock-function-name-face)
                       (when dotemacs-eshell/prompt-git-stats
                         (let* ((status (shell-command-to-string "git status --porcelain"))
                                (parts (split-string status "\n" t " "))
                                (states (mapcar #'string-to-char parts))
                                (added (count-if (lambda (char) (= char ?A)) states))
                                (modified (count-if (lambda (char) (= char ?M)) states))
                                (deleted (count-if (lambda (char) (= char ?D)) states)))
                           (when (> (+ added modified deleted) 0)
                             (propertize (format " +%d ~%d -%d" added modified deleted) 'face 'font-lock-comment-face))))
                       (propertize "]" 'face 'font-lock-keyword-face)))))
                (propertize " $ " 'face 'font-lock-constant-face))))


(when (executable-find "fortune")
  (defadvice eshell (before advice-for-eshell activate)
    (setq eshell-banner-message (concat (shell-command-to-string "fortune") "\n"))))


;; plan 9 smart shell
(when dotemacs-eshell/plan9
  (after 'esh-module
    (add-to-list 'eshell-modules-list 'eshell-smart)
    (setq eshell-where-to-jump 'begin)
    (setq eshell-review-quick-commands nil)
    (setq eshell-smart-space-goes-to-end t)))


(defun eshell/clear ()
  "Clears the buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)))


(defun eshell/ff (&rest args)
  "Opens a file in emacs."
  (when (not (null args))
    (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))


(defun eshell/j ()
  "Quickly jump to previous directories."
  (let ((candidates (delete-dups (ring-elements eshell-last-dir-ring)))
        (reader (cond ((eq dotemacs-switch-engine 'ivy) #'ivy-completing-read)
                      (t #'ido-completing-read))))
    (eshell/cd (apply reader (list "Jump to directory:" candidates)))))


(setq my-eshell-buffer-count 0)
(defun my-new-eshell-split ()
  (interactive)
  (split-window)
  (setq my-eshell-buffer-count (+ 1 my-eshell-buffer-count))
  (eshell my-eshell-buffer-count))


(add-hook 'eshell-mode-hook
	  (lambda ()
	    ;; get rid of annoying 'terminal is not fully functional' warning
	    (when (executable-find "cat")
	      (setenv "PAGER" "cat"))

            (setenv "EDITOR" "emacsclient")
            (setenv "NODE_NO_READLINE" "1")))


(provide 'init-eshell)
