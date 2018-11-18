(use-package god-mode
  :ensure t
  :config
  (global-set-key (kbd "<escape>") 'god-mode-all)
  (global-set-key (kbd "M-RET") 'god-mode-all)
  (global-set-key (kbd "<f9>") 'god-mode-all)
  (global-set-key (kbd "<f8>") 'god-mode-all)
  (define-key god-local-mode-map (kbd "œ") 'ace-window)
  (define-key god-local-mode-map (kbd "z") 'repeat)
  (define-key god-local-mode-map (kbd "&") 'zygospore-toggle-delete-other-windows)
  (define-key god-local-mode-map (kbd "é") 'split-window-below)
  (define-key god-local-mode-map (kbd "\"") 'split-window-right)
  (define-key god-local-mode-map (kbd "à") 'delete-window)
  (define-key god-local-mode-map (kbd "h") 'delete-backward-char)
  (define-key god-local-mode-map (kbd "i") 'god-mode-all)
  (define-key god-local-mode-map (kbd "<") 'beginning-of-buffer)
  (define-key god-local-mode-map (kbd ">") 'end-of-buffer)

  (global-set-key (kbd "C-x C-1") 'delete-other-windows)
  (global-set-key (kbd "C-x C-2") 'split-window-below)
  (global-set-key (kbd "C-x C-3") 'split-window-right)
  (global-set-key (kbd "C-x C-0") 'delete-window)

  (define-key god-local-mode-map (kbd "I") '(lambda () (interactive)
                                              (beginning-of-line)
                                              (open-line 1) (god-mode-all)))

  (define-key god-local-mode-map (kbd "B") 'helm-buffers-list)

  (define-key god-local-mode-map (kbd "Q") 'quit-window)

  (defun c/god-mode-update-cursor ()
    (interactive)
    (let ((limited-colors-p (> 257 (length (defined-colors)))))
      (cond (god-local-mode (progn
                              (set-face-background 'mode-line (if limited-colors-p "white" "#e9e2cb"))
                              (set-face-background 'mode-line-inactive (if limited-colors-p "white" "#e9e2cb"))))
            (t (progn
                 (set-face-background 'mode-line (if limited-colors-p "black" "#0a2832"))
                 (set-face-background 'mode-line-inactive (if limited-colors-p "black" "#0a2832")))))))

  (defun my-update-cursor ()
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                          'hollow
                        'box)))

  (add-hook 'god-mode-enabled-hook 'my-update-cursor)
  (add-hook 'god-mode-disabled-hook 'my-update-cursor)

  (add-hook 'god-local-mode-hook 'c/god-mode-update-cursor)

  ;; (define-key key-translation-map (kbd "ESC") (kbd "<escape>"))
  ;; (define-key key-translation-map (kbd "C-ESC") (kbd "ESC"))

  (require 'god-mode-isearch)
  (define-key isearch-mode-map (kbd "<escape>") 'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)

  (define-key isearch-mode-map (kbd "<f8>") 'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<f8>") 'god-mode-isearch-disable)

  ;; (setq god-exempt-major-modes nil)
  ;; (setq god-exempt-predicates nil)

  (add-to-list 'god-exempt-major-modes 'eshell-mode)

  (define-key god-local-mode-map (kbd ";") 'comment-dwim)

  )

;; (god-mode)

(provide 'setup-god-mode)
