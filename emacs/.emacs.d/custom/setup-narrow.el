(add-to-list 'load-path "~/.emacs.d/libs")
(require 'narrow-indirect)

(global-set-key (kbd "C-x n n") 'ni-narrow-to-region-indirect-other-window)
(global-set-key (kbd "C-x n d") 'ni-narrow-to-defun-indirect-other-window)

(provide 'setup-narrow)
