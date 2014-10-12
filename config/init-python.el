(defvar python2-bin-dir (expand-file-name "~/.python2/bin"))

;; Toggle python2/python3 in Emacs
(defun python-toggle ()
  (interactive)
  
  (unless (file-exists-p python2-bin-dir)
    (make-directory python2-bin-dir t)
    (make-symbolic-link "/usr/bin/python2" (concat python2-bin-dir "/python")))
  
  (if (member python2-bin-dir exec-path)
      (progn
        ;; remove dir from exec path end ENV[PATH]
        (setq exec-path (remove python2-bin-dir exec-path))
        (setenv "PATH" (mapconcat
                        'identity
                        (remove python2-bin-dir (split-string (getenv "PATH") ":")) ":"))
        (message "activate python3"))
    (setq exec-path (cons python2-bin-dir exec-path))
    (setenv "PATH" (concat python2-bin-dir ":" (getenv "PATH")))
    (message "activate python2")))

(provide 'init-python)
