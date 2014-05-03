(if (fboundp 'with-eval-after-load)
    (defmacro after (feature &rest body)
      "After FEATURE is loaded, evaluate BODY."
      (declare (indent defun))
      `(with-eval-after-load ,feature ,@body))
  (defmacro after (feature &rest body)
    "After FEATURE is loaded, evaluate BODY."
    (declare (indent defun))
    `(eval-after-load ,feature
       '(progn ,@body))))


(defmacro lazy-major-mode (pattern mode)
  "Defines a new major-mode matched by PATTERN, installs MODE if necessary, and activates it."
  `(add-to-list 'auto-mode-alist
                '(,pattern . (lambda ()
                             (require-package (quote ,mode))
                             (,mode)))))


(defun my-recompile-init ()
  "Byte-compile all your dotfiles again."
  (interactive)
  (byte-recompile-directory (concat user-emacs-directory "config") 0))


(defun my-window-killer ()
  "closes the window, and deletes the buffer if it's the last window open."
  (interactive)
  (if (> buffer-display-count 1)
      (if (= (length (window-list)) 1)
          (kill-buffer)
        (delete-window))
    (kill-buffer-and-window)))


(defun my-minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))


(defun set-transparency (alpha)
  "Sets the transparency of the current frame."
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha alpha))


(defun my-google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
                           (buffer-substring (region-beginning) (region-end))
                         (read-string "Search Google: "))))))


(defun my-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))


(defun my-rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))


(defun my-delete-current-buffer-file ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (when (y-or-n-p (format "Are you sure you want to delete %s? " filename))
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))


(defun my-goto-scratch-buffer ()
  "Create a new scratch buffer."
  (interactive)
  (progn
    (switch-to-buffer
     (get-buffer-create "*scratch*"))
    (emacs-lisp-mode)))


(defun my-describe-thing-in-popup ()
  (interactive)
  (let ((description (save-window-excursion
                       (help-xref-interned (symbol-at-point))
                       (switch-to-buffer "*Help*")
                       (buffer-string))))
    (require 'popup)
    (popup-tip description
               :point (point)
               :around t
               :height 30
               :scroll-bar t
               :margin t)))


(defadvice kill-buffer (around my-advice-for-kill-buffer activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*Scratch*")
        (bury-buffer)
      ad-do-it)))


;; make sure $PATH is set correctly
(if (eq system-type 'windows-nt)
    (dolist (path (split-string (getenv "PATH") ";"))
      (add-to-list 'exec-path (replace-regexp-in-string "\\\\" "/" path)))
  (progn
    (require-package 'exec-path-from-shell)
    (exec-path-from-shell-initialize)))

;; Samim's cofs

(defun my-add-semicolon-at-the-end-of-line ()
  "Add a semicolon to the end of line and go to next"
  (interactive) ; Do the following interactively
  (end-of-line) ; Move to the end of line
  (insert ";") ; Add the semicolon
  (evil-normal-state))

(setq path-to-ctags "TAGS")
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags-exuberant --exclude=.git -f %s -e -R %s" path-to-ctags (directory-file-name dir-name))))

(defun my-ddg ()
  "DuckDuckGo the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "https://duckduckgo.com/?q="
    (url-hexify-string (if mark-active
                           (buffer-substring (region-beginning) (region-end))
                         (read-string "Search DDG: "))))))

(defun switch-full-screen ()
 (interactive)
 (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))

(defun my-insert-today-date ()
  (interactive)
   (insert
          (format-time-string "%Y-%m-%d")))

(defun my-new-daily-journal ()
  (interactive)
  (setq my-file-name (concat "~/Note/daily/" (concat (format-time-string "%Y-%m-%d") ".org")))
  (if (file-exists-p my-file-name)
      ()
    (copy-file "~/Note/template.org" my-file-name))
  (find-file my-file-name)
  (split-window-right)
  (find-file "~/Note/todo.org"))

(provide 'init-util)
