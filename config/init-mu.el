(require 'mu4e)

;; default
;; (setq mu4e-maildir "~/Maildir")

(setq mu4e-drafts-folder "/[Gmail].Drafts")
(setq mu4e-sent-folder   "/[Gmail].Sent Mail")
(setq mu4e-trash-folder  "/[Gmail].Trash")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.

(setq mu4e-maildir-shortcuts
    '( ("/INBOX"               . ?i)
       ("/[Gmail].Sent Mail"   . ?s)
       ("/[Gmail].Trash"       . ?t)
       ("/[Gmail].All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
(setq mu4e-compose-signature-auto-include nil)
(setq
   user-mail-address "psamim@gmail.com"
   user-full-name  "Samim Pezeshki"
   mu4e-compose-signature
    (concat
      "Samim"
      "http://psam.im\n"))

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu

(require 'smtpmail)
;; (setq message-send-mail-function 'smtpmail-send-it
;;    starttls-use-gnutls t
;;    smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;;    smtpmail-auth-credentials
;;      '(("smtp.gmail.com" 587 "psamim@gmail.com" nil))
;;    smtpmail-default-smtp-server "smtp.gmail.com"
;;    smtpmail-smtp-server "smtp.gmail.com"
;;    smtpmail-smtp-service 587)

;; alternatively, for emacs-24 you can use:
(setq message-send-mail-function 'smtpmail-send-it
     smtpmail-stream-type 'starttls
     smtpmail-default-smtp-server "smtp.gmail.com"
     smtpmail-smtp-server "smtp.gmail.com"
     smtpmail-smtp-service 587)

;; use 'fancy' non-ascii characters in various places in mu4e
(setq mu4e-use-fancy-chars t)
(setq mu4e-headers-seen-mark '("S" . "☑")) ;seen
(setq mu4e-headers-unseen-mark '("u" . "☐")) ; unseen
(setq mu4e-headers-flagged-mark '("F" .  "⚵"))  ;flagged
(setq mu4e-headers-new-mark '("N" .  "✉"))  ;new
(setq mu4e-headers-replied-mark '("R" . "↵")) ;replied
(setq mu4e-headers-passed-mark '("P" . "⇉")) ;passed
(setq mu4e-headers-encrypted-mark '("x" . "⚷")) ;encrypted

;; save attachment to my desktop (this can also be a function)
(setq mu4e-attachment-dir "~/Desktop")

;; show images
(setq
 mu4e-view-show-images t
 mu4e-view-image-max-width 800)

;; Show related messages, toggles with W
(setq
 mu4e-headers-include-related t
 mu4e-headers-skip-duplicates t)

(setq mu4e-confirm-quit nil
      mu4e-headers-date-format "%d/%b/%Y %H:%M" ; date format
      mu4e-html2text-command "html2text -width 72"
      )

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; don't keep message buffers around
; mu4e-action-view-in-browser is built into mu4e
;; by adding it to these lists of custom actions
;; it can be invoked by first pressing a, then selecting
(add-to-list 'mu4e-headers-actions
             '("in browser" . mu4e-action-view-in-browser) t)
(add-to-list 'mu4e-view-actions
             '("in browser" . mu4e-action-view-in-browser) t)

(add-hook 'mu4e-compose-pre-hook
          '(lambda ()
             (interactive)
            ))

(require 'gnus-dired)
;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                   (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(setq mu4e-update-interval 300)

;; the headers to show in the headers list -- a pair of a field
;; and its width, with `nil' meaning 'unlimited'
;; (better only use that for the last field.
;; These are the defaults:
(setq mu4e-headers-fields
    '( (:human-date          .  25)
       (:flags         .   6)
       (:from          .  22)
       (:subject       .  nil)))


(define-key mu4e-main-mode-map (kbd "g") 'mu4e~headers-jump-to-maildir)
(define-key mu4e-headers-mode-map (kbd "j") 'mu4e-headers-next)
(define-key mu4e-headers-mode-map (kbd "k") 'mu4e-headers-prev)
(define-key mu4e-headers-mode-map (kbd "g") 'mu4e~headers-jump-to-maildir)

(add-hook 'mu4e-index-updated-hook
  (defun new-mail-notify ()
    (shell-command "notify-send 'New email receieved!'")))

(provide 'init-mu)
