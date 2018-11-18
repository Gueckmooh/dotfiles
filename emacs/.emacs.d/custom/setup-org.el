;;;;;;;;;;;;;;;;;;;;;;;
;;   ___  _ __ __ _  ;;
;;  / _ \| '__/ _` | ;;
;; | (_) | | | (_| | ;;
;;  \___/|_|  \__, | ;;
;;            |___/  ;;
;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :init

  (setq org-directory "~/org/")
  (setq org-default-notes-file "~/org/notes.org")

  (setq org-hide-leading-stars t)
  (setq org-alphabetical-lists t)
  (setq org-src-fontify-natively t)  ;; activate coloring in blocks
  (setq org-src-tab-acts-natively t) ;; have completion in blocks
  (setq org-hide-emphasis-markers t) ;; to hide the *,=, or / markers
  (setq org-pretty-entities t)       ;; to have \alpha, \to and others display
  ;; as utf8 http://orgmode.org/manual/Special-symbols.html

  (setq org-agenda-include-all-todo t)
  (setq org-agenda-include-diary t)

  ;; (add-hook 'org-mode-hook
  ;;           (lambda ()
  ;;             (flyspell-mode)))
  ;; (add-hook 'org-mode-hook
  ;;           (lambda ()
  ;;             (writegood-mode)))
  (add-hook 'org-mode-hook
            (lambda ()
              yas-minor-mode))

  (setq org-fast-tag-selection-single-key t)
  (setq org-use-fast-todo-selection t)
  (setq org-startup-truncated nil)

  ;; seting up the todo flags
  (setq org-log-done t)
  (setq org-todo-keywords
        '(
          (sequence "TODO(t)" "INPROGRESS(i)" "|" "DONE(d!)")
          (sequence "REPORT(r)" "BUG(b@)" "KNOWNCAUSE(k)" "|" "FIXED(f/!)")
          (sequence "|" "CANCELED(c@/!)")
          (type "LAURENCE(l)" "|" "DONE(d!)")
          (sequence "PLAN-TO-WATCH(p)" "WATCHING(w)" "HOLD(h)" "|" "WATCHED(x!)")
          ))

  (setq org-todo-keyword-faces
        '(
          ("INPROGRESS" . (:foreground "blue" :weight bold))
          ))

  (setq org-tag-persistent-alist
        '((:startgroup . nil)
          ("HOME" . ?h)
          ("FAC" . ?f)
          ("RESEARCH" . ?r)
          ("TEACHING" . ?t)
          (:endgroup . nil)
          (:startgroup . nil)
          ("OS" . ?o)
          ("DEV" . ?d)
          (:endgroup . nil)
          (:startgroup . nil)
          ("EASY" . ?e)
          ("MEDIUM" . ?m)
          ("HARD" . ?a)
          (:endgroup . nil)
          ("URGENT" . ?u)
          ("KEY" . ?k)
          ("BONUS" . ?b)
          ("noexport" . ?x)
          )
        )

  (setq org-tag-faces
        '(
          ("HOME" . (:foreground "GoldenRod" :weight bold))
          ("RESEARCH" . (:foreground "GoldenRod" :weight bold))
          ("TEACHING" . (:foreground "GoldenRod" :weight bold))
          ("FAC" . (:foreground "IndianRed1" :weight bold))
          ("OS" . (:foreground "IndianRed1" :weight bold))
          ("DEV" . (:foreground "IndianRed1" :weight bold))
          ("URGENT" . (:foreground "Red" :weight bold))
          ("KEY" . (:foreground "Red" :weight bold))
          ("EASY" . (:foreground "OrangeRed" :weight bold))
          ("MEDIUM" . (:foreground "OrangeRed" :weight bold))
          ("HARD" . (:foreground "OrangeRed" :weight bold))
          ("BONUS" . (:foreground "GoldenRod" :weight bold))
          ("noexport" . (:foreground "LimeGreen" :weight bold))
          )
        )

  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c b") 'org-iswitchb)

  (defun insert-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "** %Y-%m-%d")
                   ((equal prefix '(4)) "[%Y-%m-%d]"))))
      (insert (format-time-string format))))
  (global-set-key (kbd "C-c d") 'insert-date)


  (defun insert-time-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "[%H:%M:%S; %d.%m.%Y]")
                   ((equal prefix '(4)) "[%H:%M:%S; %Y-%m-%d]"))))
      (insert (format-time-string format))))
  (global-set-key (kbd "C-c t") 'insert-time-date)


  )

(use-package ob-async
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh . t)
     (shell . t)
     (ditaa . t)
     (R . t)
     (python . t)
     (perl . t)
     (plantuml . t)
     (org . t)
     (dot . t)
     (ruby . t)
     (js . t)
     (C . t)
     (awk . t)
     (latex . t)
     (ocaml . t)
     (calc . t)
     ))

  (setq org-babel-python-command
        (if (memq system-type '(windows-nt ms-dos))
            "Python"
          "python3"))

  (add-to-list 'org-src-lang-modes (quote ("dot". graphviz-dot)))
  (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
  (add-to-list 'org-babel-tangle-lang-exts '("clojure" . "clj"))

  (defvar org-babel-default-header-args:clojure
    '((:results . "silent") (:tangle . "yes")))

  (defun org-babel-execute:clojure (body params)
    (lisp-eval-string body)
    "Done!")

  (setq org-src-fontify-natively t
        org-confirm-babel-evaluate nil)

  (setq org-ditaa-jar-path "/usr/share/ditaa/ditaa.jar")

  (add-hook 'org-babel-after-execute-hook (lambda ()
                                            (condition-case nil
                                                (org-display-inline-images)
                                              (error nil)))
            'append)

  (add-hook 'org-mode-hook 'org-display-inline-images)
  (add-hook 'org-mode-hook 'org-babel-result-hide-all)

  (global-set-key (kbd "C-c S-t") 'org-babel-execute-subtree)

  (add-to-list 'org-structure-template-alist
               '("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("m" "#+begin_src emacs-lisp :tangle init.el\n\n#+end_src" "<src lang=\"emacs-lisp\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("r" "#+begin_src R :results output :session *R* :exports both\n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("R" "#+begin_src R :results output graphics :file (org-babel-temp-file \"figure\" \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("b" "#+begin_src shell :results output :exports both\n\n#+end_src" "<src lang=\"shell\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("RR" "#+begin_src R :results output graphics :file  (org-babel-temp-file (concat (file-name-directory (or load-file-name buffer-file-name)) \"figure-\") \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("p" "#+begin_src python :results output :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("P" "#+begin_src python :results output :session :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

  (add-to-list 'org-structure-template-alist
               '("PP" "#+begin_src python :results file :session :var matplot_lib_filename=(org-babel-temp-file \"figure\" \".png\") :exports both\nimport matplotlib.pyplot as plt\n\nimport numpy\nx=numpy.linspace(-15,15)\nplt.figure(figsize=(10,5))\nplt.plot(x,numpy.cos(x)/x)\nplt.tight_layout()\n\nplt.savefig(matplot_lib_filename)\nmatplot_lib_filename\n#+end_src" "<src lang=\"python\">\n\n</src>"))

  )

(use-package org-ref)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'org-plus-contrib)
  (package-install 'org-plus-contrib))

(provide 'setup-org)
