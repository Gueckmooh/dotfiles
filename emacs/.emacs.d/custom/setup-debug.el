;;;;;;;;;;;;;;;;;;;;;;;;;
;;            _ _      ;;
;;   __ _  __| | |__   ;;
;;  / _` |/ _` | '_ \  ;;
;; | (_| | (_| | |_) | ;;
;;  \__, |\__,_|_.__/  ;;
;;  |___/              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t)

(provide 'setup-debug)
