(defcustom
  flycheck-clang-args
  flycheck-clang-warnings
  flycheck-clang-include-path
  :safe (lambda (x) t))

;; (add-to-list 'safe-local-variable-values
;;              '(flycheck-clang-args . ("-D__DEBUG"))
;;              '(flycheck-clang-args . ("`xml2-config --cflags`" "-D__DEBUG"))
;;              '(flycheck-clang-warnings . ("all" "extra" "shadow"))
;;              '(flycheck-clang-include-path . ("`xml2-config --libs`")))

(provide 'setup-safe-local-variables)
