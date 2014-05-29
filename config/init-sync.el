(setq psamim-mobile-inbox-org-file "~/Note/inbox.org")
(setq psamim-mobile-todo-org-file "~/Note/mobile.org")
(setq psamim-mobile-inbox-list "Inbox")
(setq psamim-mobile-todo-list "org-todos")

(defun psamim-push-gtasks-todos ()
  "Asynchronously syncs to Google tasks"
  (interactive)
  (org-tags-sparse-tree t "+TODO=\"NEXT\"")
  (org-export-visible ?\s nil)
  (delete-matching-lines "^\* .*")
  (replace-string "** NEXT" "*")
  (write-file psamim-mobile-org-file nil)
  (my-window-killer)
  (message "Sync started")
  (let ((process
         (start-process
          "gtasks-sync" "*sync-output*" "/bin/sh" "-c"
          (concat
           "torify ~/src/michel-orgmode/michel/michel.py --push --orgfile "
           psamim-mobile-todo-org-file
           " --listname "
           psamim-mobile-todo-list))))
    (set-process-sentinel process 'gtasks-sentinel)))

(defun psamim-pull-gtasks-inbox ()
  "Asynchronously syncs to Google tasks"
  (interactive)
  (message "Sync started")
  (let ((process
         (start-process
          "gtasks-sync" "*sync-output*" "/bin/sh" "-c"
          (concat
           "torify ~/src/michel-orgmode/michel/michel.py --pull --orgfile "
           psamim-mobile-inbox-org-file
           " --listname "
           psamim-mobile-inbox-list))))
    (set-process-sentinel process 'gtasks-sentinel)))

(defun psamim-push-gtasks-inbox ()
  "Asynchronously syncs to Google tasks"
  (interactive)
  (message "Sync started")
  (let ((process
         (start-process
          "gtasks-sync" "*sync-output*" "/bin/sh" "-c"
          (concat
           "torify ~/src/michel-orgmode/michel/michel.py --push --orgfile "
           psamim-mobile-inbox-org-file
           " --listname "
           psamim-mobile-inbox-list))))
    (set-process-sentinel process 'gtasks-sentinel)))

(defun gtasks-sentinel (p e)
  "Display the result of the sync"
  (if (= 0 (process-exit-status p))
      (message "Google tasks sync was successful")
    (message "Sync failed")))

(provide 'init-sync)
