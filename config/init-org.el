(require 'org)
(setq org-default-notes-file "~/Dropbox/notes/notes.org"
      org-log-done t
      org-startup-indented t
      org-export-babel-evaluate nil
      org-indent-indentation-per-level 3)

(require-package 'org-bullets)
(require 'org-bullets)

(require-package 'ox-reveal)
(require 'ox-reveal)

(require 'epa-file)
(epa-file-enable)
(setq epa-file-select-keys nil)

(require-package 'org-ac)
(require 'org-ac)
(org-ac/config-default)

(defun my-org-mode-hook()
  (org-indent-mode)
  (setq bidi-paragraph-direction nil)
  (auto-complete-mode t)
  (org-bullets-mode 1)
  (flyspell-mode t)
  (writegood-turn-on)
  (ac-flyspell-workaround)
  (load-library "reftex")
  (after 'evil
    (define-key evil-normal-state-map (kbd "C-S-j") 'flyspell-goto-next-error)
    (define-key evil-normal-state-map (kbd "C-S-k") 'flyspell-check-previous-highlighted-word)))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq org-todo-keywords '("TODO" "NEXT" "WAITING" "DONE"))

;; Show sum of clocks in hours
(setq org-time-clocksum-format
      (quote
       (:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t)))

;; make org-archive-subtree keep inherited tags
(defadvice org-archive-subtree
  (before add-inherited-tags-before-org-archive-subtree activate)
    "add inherited tags before org-archive-subtree"
    (org-set-tags-to (org-get-tags-at)))

(defvar ash-org-current-task-loc nil
"A cons of the buffer & location of the current task")

(defadvice org-clock-in (after ash-org-mark-task activate)
"When the user clocks in, bind F9 to go back to the worked on task."

(setq ash-org-current-task-loc (cons (current-buffer)
                                     (point)))
(define-key global-map [f9] (lambda ()
                              (interactive)
                              (switch-to-buffer
                               (car ash-org-current-task-loc))
                              (goto-char
                               (cdr ash-org-current-task-loc)))))

(require 'ob)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (org . t)
   (plantuml . t)
   (latex . t)
   (emacs-lisp . t)
   (sh . t)
   (sql . nil)))
(setq org-plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar"))
(setq org-confirm-babel-evaluate nil)

;; Display code-block natively
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(require-package 'htmlize)

(setq org-edit-src-auto-save-idle-delay 5)
(setq org-edit-src-content-indentation 0)

(add-hook 'org-src-mode-hook
          (lambda ()
            (make-local-variable 'evil-ex-commands)
            (setq evil-ex-commands (copy-list evil-ex-commands))
            (evil-ex-define-cmd "w[rite]" 'org-edit-src-save)))


; Custom agendas and trees
(setq org-agenda-custom-commands
      (quote (
              ("tt" "All todos" tags-tree "TODO=\"TODO\"|TODO=\"NEXT\"")
              ("tn" "All todos" tags-tree "TODO=\"NEXT\"")
              ("un" "@uni NEXT" tags-tree "@uni+TODO=\"NEXT\"")
              ("ut" "@uni TODO" tags-tree "@uni+TODO=\"TODO\"")
              ("ua" "@uni ALL" tags-tree "@uni+TODO=\"NEXT\"|@uni+TODO=\"TODO\"")
              ("wn" "@work NEXT" tags-tree "@work+TODO=\"NEXT\"")
              ("wt" "@work TODO" tags-tree "@work+TODO=\"TODO\"")
              ("wa" "@work ALL" tags-tree "@work+TODO=\"NEXT\"|@work+TODO=\"TODO\"")
              ;; ("mn" "@me NEXT" tags-tree "@me+TODO=\"NEXT\"|@tasks+TODO=\"NEXT\"")
              ;; ("mt" "@me TODO" tags-tree "@me+TODO=\"TODO\"|@tasks+TODO=\"TODO\"")
              ;; ("ma" "@me ALL" tags-tree "@me+TODO=\"TODO\"|@tasks+TODO=\"TODO\"|@me+TODO=\"NEXT\"|@tasks+TODO=\"NEXT\"")

              ("wg" "Work Agenda"
               (
                (tags-todo "@work+TODO=\"NEXT\"")
                (tags-todo "@work+TODO=\"TODO\"")
                )
               ((org-agenda-compact-blocks t))) ;; options set here apply to the entire block

              ("ug" "Uni Agenda"
               (
                (tags-todo "@uni+TODO=\"NEXT\"")
                (tags-todo "@uni+TODO=\"TODO\"")
                )
               ((org-agenda-compact-blocks t))) ;; options set here apply to the entire block

              ("mg" "Me Agenda"
               (
                (tags-todo "@me+TODO=\"NEXT\"|@tasks+TODO=\"NEXT\"")
                (tags-todo "@me+TODO=\"TODO\"|@tasks+TODO=\"TODO\"")
                )
               ((org-agenda-compact-blocks t))) ;; options set here apply to the entire block

              )))


(setq org-agenda-files (quote ("~/Dropbox/notes/todo.org")))
;; (setq org-mobile-directory "~/Owncloud/orgs")
;; (setq org-mobile-directory "~/.orgs/mob")
(setq org-directory "~/Dropbox/notes")
;; (setq org-mobile-inbox-for-pull "~/Dropbox/notes/mob.org")
(setq org-archive-location "~/Dropbox/notes/archive/todo.org::")
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 2)
                                 ("~/Dropbox/notes/ideas.org" :maxlevel . 1))))
;; Syntax Highlighting
;; http://joat-programmer.blogspot.com/2013/07/org-mode-version-8-and-pdf-export-with.html
;; Include the latex-exporter
(require 'ox-latex)
(require 'ox-beamer)
;; Add minted to the defaults packages to include when exporting.
(add-to-list 'org-latex-packages-alist '("" "minted" nil))
;; Tell the latex export to use the minted package for source
;; code coloration.
(setq org-latex-listings 'minted)
;; Let the exporter use the -shell-escape option to let latex
;; execute external programs.
;; This obviously and can be dangerous to activate!
(setq org-latex-pdf-process
      (quote ("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
              "biber %b"
              "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")))

(require-package 'writegood-mode)
(require 'writegood-mode)

(setq org-clock-into-drawer t)
(setq org-latex-minted-options
      '(("frame" "leftline")
        ("fontsize" "\\scriptsize")
        ("bgcolor" "bg")
        ("stepnumber" "2")
        ("mathescape" "true")
        ("linenos" "true")))

;; Open PDFs after Export with Zathura
(custom-set-variables '(org-file-apps (quote ((auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . default) ("\\.pdf\\'" . "zathura %s")))))



;; My latex templates for org-mode
;; (require 'org-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

(add-to-list 'org-latex-classes
             '("doc-fa"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{fontspec}
\\usepackage{longtable}
\\usepackage{graphicx}
\\usepackage{geometry}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{enumerate}
\\usepackage{color}
\\definecolor{bg}{rgb}{0.95,0.95,0.95}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty}
      [NO-DEFAULT-PACKAGES]
      [PACKAGES]
      [EXTRA]
\\usepackage{xepersian}
\\linespread{1.4}
\\hypersetup{pdfborder=0 0 0}
\\let\\oldtextbf\\textbf
\\renewcommand{\\textbf}[1]{\\textcolor{red}{\\oldtextbf{#1}}}
\\settextfont{XB Yas}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("article-fa"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[T1]{fontenc}
\\usepackage{fontspec}
\\usepackage{longtable}
\\usepackage{graphicx}
\\usepackage{geometry}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{enumerate}
\\usepackage{color}
\\definecolor{bg}{rgb}{0.95,0.95,0.95}
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty}
      [NO-DEFAULT-PACKAGES]
      [PACKAGES]
      [EXTRA]
\\usepackage{xepersian}
\\linespread{1.4}
\\hypersetup{pdfborder=0 0 0}
\\settextfont{Yas}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(add-to-list 'org-latex-classes
             '("assignment"
               "\\documentclass[11pt,a4paper]{article}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{fixltx2e}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{mathpazo}
\\usepackage{color}
\\usepackage{enumerate}
\\definecolor{bg}{rgb}{0.95,0.95,0.95}
\\tolerance=1000
      [NO-DEFAULT-PACKAGES]
      [PACKAGES]
      [EXTRA]
\\linespread{1.1}
\\hypersetup{pdfborder=0 0 0}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")))


;; RefTeX formats for biblatex (not natbib)
;; C-c [ and one the below citing styles
(setq reftex-cite-format
      '(
        (?\C-m . "\\cite[]{%l}")
        (?t . "\\textcite{%l}")
        (?a . "\\autocite[]{%l}")
        (?p . "\\parencite{%l}")
        (?f . "\\footcite[][]{%l}")
        (?F . "\\fullcite[]{%l}")
        (?x . "[]{%l}")
        (?X . "{%l}")
        ))

;; Calendar Settings
(require-package 'calfw)
(require 'calfw-cal)
(require 'calfw-org)
(require 'calfw-ical)
(setq calendar-week-start-day 6) ; 0:Sunday, 1:Monday

(defun psamim-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "gainsboro")  ; orgmode source
    (cfw:ical-create-source "gcal"
                            "https://www.google.com/calendar/ical/fm79ocs70hfo6b8q1qsp3mj6b4%40group.calendar.google.com/public/basic.ics"
                            "grey40"))))

(defun psamim-cfw-hook()
  (evil-emacs-state))

(after 'cfw:calendar-mode
(add-hook 'cfw:calendar-mode-hook 'psamim-cfw-hook))

(custom-set-variables
 '(cfw:display-calendar-holidays nil)
 '(org-agenda-files (quote ("~/Dropbox/notes/todo.org")))
 '(org-agenda-ndays 7)
 '(org-deadline-warning-days 14)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-reverse-note-order t))

(provide 'init-org)
