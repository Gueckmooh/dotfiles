;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  _   _    _    ____  ____   ____ ___  ____  _____  ;;
;; | | | |  / \  |  _ \|  _ \ / ___/ _ \|  _ \| ____| ;;
;; | |_| | / _ \ | |_) | | | | |  | | | | |_) |  _|   ;;
;; |  _  |/ ___ \|  _ <| |_| | |__| |_| |  _ <| |___  ;;
;; |_| |_/_/   \_\_| \_\____/ \____\___/|_| \_\_____| ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use shell-like backspace C-h, rebind help to F1
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f1>") 'help-command)

(use-package hardcore-mode
  :init
  (global-hardcore-mode))

(provide 'setup-hardcore)
