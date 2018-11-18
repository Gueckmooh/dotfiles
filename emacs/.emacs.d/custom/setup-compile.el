;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            _ _       ;;
;;   ___ ___  _ __ ___  _ __ (_) | ___  ;;
;;  / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ ;;
;; | (_| (_) | | | | | | |_) | | |  __/ ;;
;;  \___\___/|_| |_| |_| .__/|_|_|\___| ;;
;;                     |_|              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package smart-compile)

(add-to-list 'smart-compile-alist '("\\.tex\\'" . "rubber -d %f"))

(defun desperately-compile ()
  "Traveling up the path, find a Makefile and `compile'."
  (interactive)
  (setq compile-command "make -k")
  (when (locate-dominating-file default-directory "Makefile")
    (with-temp-buffer
      (cd (locate-dominating-file default-directory "Makefile"))
      (call-interactively #'compile))))

(define-key c++-mode-map (kbd "C-x RET RET") 'desperately-compile)
(define-key c-mode-map (kbd "C-x RET RET") 'desperately-compile)

(define-key c++-mode-map (kbd "C-c RET") 'compile)
(define-key c-mode-map (kbd "C-c RET") 'compile)

(provide 'setup-compile)
