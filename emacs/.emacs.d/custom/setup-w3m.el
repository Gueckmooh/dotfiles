(use-package w3m
  :ensure t
  :config
  (setq browse-url-browser-function 'w3m-browse-url)
  (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

  (defun w3m-add-to-emms ()
  "Open the current link or image in Firefox."
  (interactive)
  (let ((url (or (w3m-anchor) (w3m-image))))
   (if (string-match "youtube" url)
       (emms-add-url url)
     (browse-url-generic url))))

  ;; optional keyboard short-cut
  (global-set-key "\C-xm" 'browse-url-at-point)
  ;; (global-set-key (kbd "C-c m y"))
  (define-key w3m-mode-map (kbd "C-y") 'w3m-add-to-emms)
  )

(provide 'setup-w3m)
