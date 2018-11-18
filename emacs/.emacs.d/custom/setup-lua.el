;;;;;;;;;;;;;;;;;;;;;
;;  _              ;;
;; | |_   _  __ _  ;;
;; | | | | |/ _` | ;;
;; | | |_| | (_| | ;;
;; |_|\__,_|\__,_| ;;
;;;;;;;;;;;;;;;;;;;;;

(use-package lua-mode)
(add-hook 'lua-mode-hook 'yas-minor-mode)
(add-hook 'lua-mode-hook 'flycheck-mode)
(add-hook 'lua-mode-hook 'company-mode)

(defun custom-lua-repl-bindings ()
  (local-set-key (kbd "C-c C-s") 'lua-show-process-buffer)
  (local-set-key (kbd "C-c C-h") 'lua-hide-process-buffer))

(defun lua-mode-company-init ()
  (setq-local company-backends '((company-lua
                                  company-etags
                                  company-dabbrev-code))))

(use-package company-lua
  :ensure t
  :config
    (require 'company)
    (setq lua-indent-level 4)
    (setq lua-indent-string-contents t)
    (add-hook 'lua-mode-hook 'custom-lua-repl-bindings)
    (add-hook 'lua-mode-hook 'lua-mode-company-init))

(provide 'setup-lua)
