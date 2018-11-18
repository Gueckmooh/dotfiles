;;;;;;;;;;;;;
;;   ____  ;;
;;  / ___| ;;
;; | |     ;;
;; | |___  ;;
;;  \____| ;;
;;;;;;;;;;;;;

(require 'cc-mode)

(setq c-default-style "gnu")

;; (if (version< "25" emacs-version)
;;     (use-package fill-column-indicator
;;       :init
;;       (setq fci-rule-column 80)
;;       (setq fci-rule-color "#2b2b2b")

;;       (add-hook 'c-mode-hook 'fci-mode)
;;       (add-hook 'c++-mode-hook 'fci-mode)))

(use-package function-args
  :init
  (fa-config-default)
  (set-default 'semantic-case-fold t)
  (define-key c-mode-map (kbd "M-*") 'fa-show)
  (define-key c++-mode-map (kbd "M-*") 'fa-show)
  (define-key function-args-mode-map (kbd "M-n") nil))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; (use-package electric-spacing
;;   :init
;;   (add-hook 'c-mode-hook 'electric-spacing-mode)
;;   (add-hook 'c++-mode-hook 'electric-spacing-mode))

;; replaced by company :)

;; (use-package auto-complete
;;   :init
;;   (ac-config-default))

;; (use-package ac-c-headers
;;   :init
;;   (add-hook 'c-mode-hook
;;             (lambda ()
;;               (add-to-list 'ac-sources 'ac-source-c-headers)
;;               (add-to-list 'ac-sources 'ac-source-c-header-symbols t))))

(add-hook 'c++-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)

(use-package flycheck-clang-analyzer
  :ensure t
  :config
  (with-eval-after-load 'flycheck
    (require 'flycheck-clang-analyzer)
     (flycheck-clang-analyzer-setup)))

(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook
          (lambda ()
            (setq flycheck-gcc-language-standard "c++11")))
(add-hook 'c++-mode-hook
          (lambda ()
            (setq flycheck-clang-language-standard "c++11")))

(provide 'setup-c)
