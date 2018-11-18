;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  ____    _    ____  _   _  ;;
;; | __ )  / \  / ___|| | | | ;;
;; |  _ \ / _ \ \___ \| |_| | ;;
;; | |_) / ___ \ ___) |  _  | ;;
;; |____/_/   \_\____/|_| |_| ;;
;;                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use yasnippet, flycheck and company
(add-hook 'shell-mode-hook 'yas-minor-mode)
(add-hook 'shell-mode-hook 'flycheck-mode)
(add-hook 'shell-mode-hook 'company-mode)

(add-hook 'sh-mode-hook 'yas-minor-mode)
(add-hook 'sh-mode-hook 'flycheck-mode)
(add-hook 'sh-mode-hook 'company-mode)

;; Try to force shellcheck to check bash script
;; I'm not even sure that it actualy calls shellcheck
;; (setq flycheck-sh-bash-args . ("-s bash"))

(defun shell-mode-company-init ()
  (setq-local company-backends '((company-shell
                                  company-shell-env
                                  company-etags
                                  company-dabbrev-code))))

(use-package company-shell
  :ensure t
  :config
    (require 'company)
    (add-hook 'shell-mode-hook 'shell-mode-company-init))

(provide 'setup-bash)
