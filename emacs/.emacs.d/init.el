(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository<>>>
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/") t)


(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")
(add-to-list 'load-path "~/.emacs.d/libs")

;; -------------------- REQUIRES --------------------

(require 'setup-general)
(require 'setup-helm)
(require 'setup-vhdl)
(require 'setup-magit)
(require 'setup-autopair)
(require 'setup-yasnippet)
(require 'setup-flycheck)
(require 'setup-c)
(require 'setup-bash)
(require 'setup-format)
(require 'setup-compile)
(require 'setup-lua)
(require 'setup-org)
(require 'setup-python)
(require 'setup-debug)
(require 'setup-latex)
(require 'setup-company)
(require 'setup-editing)
(require 'setup-minimap)
(require 'setup-bison)
(require 'setup-w3m)
(require 'setup-ggtags)
(require 'setup-narrow)
(require 'setup-emms)
(require 'setup-doxymacs)
(require 'setup-java)
(require 'setup-god-mode)
(require 'setup-awk)
(require 'setup-safe-local-variables)
(require 'setup-rust)
(require 'setup-ocaml)
(require 'setup-R)
;; additional libs
;; (require 'zones)
;; (require 'narrow-indirect)
;; Uncomment the following line to get hardcore mode
;; (require 'setup-hardcore)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("" . "~/.emacs_backups"))))
 '(custom-safe-themes
   (quote
    ("12dd37432bb454355047c967db886769a6c60e638839405dad603176e2da366b" default)))
 '(jdee-global-classpath
   (quote
    ("/home/brignone/git/osiris/src/" "/home/brignone/git/osiris/java-cup-11a-runtime.jar")))
 '(jdee-server-dir "~/.emacs.d/jdee/")
 '(org-agenda-files
   (quote
    ("~/Documents/org/animes-list.org" "~/Documents/Cours/M2/Software-security/TP/lab1/report.org" "~/Documents/Cours/M2/IOT/IOT.org" "~/Documents/Cours/M2/Scientific-method/Scientific-method.org" "~/Documents/Cours/M2/Software-security/Software-security.org")))
 '(package-selected-packages
   (quote
    (flymake-shellcheck google-translate org-preview-html org-journal graphviz-dot-mode org-plus-contrib babel cobol-mode cargo flymake-rust rust-mode writegood-mode elscreen htmlize darkroom-mode god-mode jdee volume flycheck-clang-analyzer company-shell helm-emms emms-setup-vlc multiple-cursors ansi helm-projectile projectile csv-mode xkcd minimap eshell-z eshell-up eshell-prompt-extras eshell-git-prompt eshell-fringe-status eshell-did-you-mean ess company-jedi smart-compile yasnippet-snippets tex auctex hardcore-mode anaconda-mode virtualenvwrapper elpy company-c-headers company-c-header company ob ac-c-headers auto-complete lua-mode move-text auto-highlight-symbol autopair magit undo-tree buffer-move ace-jump-mode ace-jump ace-window electric-spacing vhdl-tools helm-swoop helm zygospore beacon powerline flycheck use-package)))
 '(safe-local-variable-values
   (quote
    ((jdee-global-classpath "/home/brignone/git/osiris/src/" "/home/brignone/git/osiris/java-cup-11a-runtime.jar")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((t (:background "#2b2b2b")))))
(put 'narrow-to-region 'disabled nil)
