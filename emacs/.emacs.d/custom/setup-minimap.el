(use-package minimap
  :init
  (setq-default minimap-hide-scroll-bar nil)
  (setq-default minimap-window-location 'right)

  (custom-set-faces
   '(minimap-active-region-background ((t (:background "#2b2b2b")))))

  (global-set-key (kbd "M-ù") 'minimap-mode)
  )


(provide 'setup-minimap)
