(use-package tuareg)

(use-package utop
  :init
  (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
  (add-hook 'tuareg-mode-hook 'utop-minor-mode)
)

(provide 'setup-ocaml)
