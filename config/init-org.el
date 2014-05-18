(require 'org)
(setq org-default-notes-file "~/Note/notes.org"
      org-log-done t)

(require-package 'org-bullets)
(require 'org-bullets)

(require-package 'ox-reveal)
(require 'ox-reveal)

(require 'epa-file)
(epa-file-enable)
(setq epa-file-select-keys nil)

(defun my-org-mode-hook()
  (setq bidi-paragraph-direction nil)
  (auto-complete-mode t)
  (org-bullets-mode 1)
  (flyspell-mode t))

(add-hook 'org-mode-hook 'my-org-mode-hook)

(setq org-todo-keywords '("TODO" "NEXT" "WAITING" "DONE"))

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
'((plantuml . t)))

(setq org-plantuml-jar-path (expand-file-name "~/Downloads/plantuml.jar"))


; Custom agendas and trees
(setq org-agenda-custom-commands
      (quote (
        ("d" "All todos" tags-tree "+TODO=\"TODO\"")
        ("un" "@uni NEXT" tags-tree "@uni+TODO=\"NEXT\"")
        ("ut" "@uni TODO" tags-tree "@uni+TODO=\"TODO\"")
        ("ua" "@uni ALL" tags-tree "@uni+TODO=\"NEXT\"|@uni+TODO=\"TODO\"")
        ("wn" "@work NEXT" tags-tree "@work+TODO=\"NEXT\"")
        ("wt" "@work TODO" tags-tree "@work+TODO=\"TODO\"")
        ("wa" "@work ALL" tags-tree "@work+TODO=\"NEXT\"|@work+TODO=\"TODO\"")
        ("mn" "@me NEXT" tags-tree "@me+TODO=\"NEXT\"|@tasks+TODO=\"NEXT\"")
        ("mt" "@me TODO" tags-tree "@me+TODO=\"TODO\"|@tasks+TODO=\"TODO\"")
        ("ma" "@me ALL" tags-tree "@me+TODO=\"TODO\"|@tasks+TODO=\"TODO\"|@me+TODO=\"NEXT\"|@tasks+TODO=\"NEXT\"")

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


(setq org-agenda-files (quote ("~/Note/todo.org")))
(setq org-mobile-directory "~/Owncloud/orgs")
;; (setq org-mobile-directory "~/.orgs/mob")
(setq org-directory "~/Note")
(setq org-mobile-inbox-for-pull "~/Note/mob.org")

;; Syntax Highlighting
;; http://praveen.kumar.in/2012/03/10/org-mode-latex-and-minted-syntax-highlighting/
;; (require 'org-latex)
;; (setq org-export-latex-listings 'minted)
;; (add-to-list 'org-export-latex-packages-alist '("" "minted"))

;; http://joat-programmer.blogspot.com/2013/07/org-mode-version-8-and-pdf-export-with.html
;; Include the latex-exporter
(require 'ox-latex)
;; Add minted to the defaults packages to include when exporting.
(add-to-list 'org-latex-packages-alist '("" "minted"))
;; Tell the latex export to use the minted package for source
;; code coloration.
(setq org-latex-listings 'minted)
;; Let the exporter use the -shell-escape option to let latex
;; execute external programs.
;; This obviously and can be dangerous to activate!
(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; My latex templates for org-mode
(require 'org-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))

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
\\geometry{a4paper, textwidth=6.5in, textheight=10in,
            marginparsep=7pt, marginparwidth=.6in}
\\pagestyle{empty}
\\usepackage{xepersian}
      [NO-DEFAULT-PACKAGES]
      [NO-PACKAGES]
\\linespread{1.4}
\\hypersetup{pdfborder=0 0 0}
\\settextfont{Yas}"
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(provide 'init-org)
