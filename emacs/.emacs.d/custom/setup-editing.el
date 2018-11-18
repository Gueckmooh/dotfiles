;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           _ _ _   _              ;;
;;   ___  __| (_) |_(_)_ __   __ _  ;;
;;  / _ \/ _` | | __| | '_ \ / _` | ;;
;; |  __/ (_| | | |_| | | | | (_| | ;;
;;  \___|\__,_|_|\__|_|_| |_|\__, | ;;
;;                           |___/  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GROUP: Editing -> Editing Basics
(setq global-mark-ring-max 5000         ; increase mark ring to contains 5000 entries
      mark-ring-max 5000                ; increase kill ring to contains 5000 entries
      mode-require-final-newline t      ; add a newline to end of file
      )

;; GROUP: Editing -> Killing
(setq kill-ring-max 5000 ; increase kill-ring capacity
      kill-whole-line t  ; if NIL, kill whole line and move the next line up
      )

(setq-default indent-tabs-mode nil)
(delete-selection-mode)
(global-set-key (kbd "RET") 'newline-and-indent)

;; kill a line, including whitespace characters until next non-whiepsace character
;; of next line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

(show-paren-mode t)
(use-package auto-highlight-symbol
  :init
  (add-hook 'prog-mode-hook 'auto-highlight-symbol-mode))

(require 'cc-mode)

(use-package move-text
  :init
  (define-key c-mode-map (kbd "M-C-p") 'move-text-up)
  (define-key c++-mode-map (kbd "M-C-p") 'move-text-up)
  (define-key lua-mode-map (kbd "M-C-p") 'move-text-up)

  (define-key c-mode-map (kbd "M-C-n") 'move-text-down)
  (define-key c++-mode-map (kbd "M-C-n") 'move-text-down)
  (define-key lua-mode-map (kbd "M-C-n") 'move-text-down))

;; for moving the cursor ->
(define-key c-mode-map (kbd "M-p") 'backward-paragraph)
(define-key c-mode-map (kbd "M-P") 'backward-list)
(define-key c-mode-map (kbd "M-n") 'forward-paragraph)
(define-key c-mode-map (kbd "M-N") 'forward-list)

(define-key c++-mode-map (kbd "M-p") 'backward-paragraph)
(define-key c++-mode-map (kbd "M-P") 'backward-list)
(define-key c++-mode-map (kbd "M-n") 'forward-paragraph)
(define-key c++-mode-map (kbd "M-N") 'forward-list)

(define-key lua-mode-map (kbd "M-p") 'backward-paragraph)
(define-key lua-mode-map (kbd "M-P") 'backward-list)
(define-key lua-mode-map (kbd "M-n") 'forward-paragraph)
(define-key lua-mode-map (kbd "M-N") 'forward-list)

(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-P") 'backward-list)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-N") 'forward-list)

(defun mymajline ()
  (setq linum-format
        (let ((w (length (number-to-string
                          (count-lines (point-min) (point-max))))))
          (concat "%" (number-to-string w) "d\u2502"))))

;; (add-hook 'linum-before-numbering-hook 'mymajline)

;; (global-linum-mode t)
(defun toggle-linum ()
  (linum-mode 1))

(add-hook 'c-mode-hook 'toggle-linum)
(add-hook 'c++-mode-hook 'toggle-linum)
(add-hook 'java-mode-hook 'toggle-linum)
(add-hook 'emacs-lisp-mode-hook 'toggle-linum)

;; (defun format-when-save ()
;;   (add-hook 'before-save-hook
;;             (lambda ()
;;               (setq delete-trailing-lines t)
;;               (delete-trailing-whitespace (point-min))
;;               (indent-region (point-min) (point-max)))))


(defun format-when-save ()
  (add-hook 'before-save-hook
            (lambda ()
              (setq delete-trailing-lines t)
              (delete-trailing-whitespace (point-min)))))

(add-hook 'prog-mode-hook 'format-when-save)

;; (if (version< "25" emacs-version)
;;     (use-package fill-column-indicator
;;       :init
;;       (setq fci-rule-column 80)
;;       ;; (setq fci-rule-color "#2b2b2b")
;;       (setq fci-rule-color "#7c0911")

;;       (add-hook 'c-mode-hook 'fci-mode)
;;       (add-hook 'c++-mode-hook 'fci-mode)
;;       (add-hook 'python-mode-hook 'fci-mode)))

(global-set-key (kbd "M-SPC") 'helm-all-mark-rings) ;; remplace 'just-one-space

(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(add-hook 'c-mode-common-hook 'hs-minor-mode)

(add-hook 'java-mode-hook 'hs-minor-mode)

(define-key c-mode-map (kbd "C-c n c") 'hs-toggle-hiding)
(define-key c-mode-map (kbd "C-c n l") 'hs-hide-level)
(define-key c-mode-map (kbd "C-c n a") 'hs-show-all)

(define-key c++-mode-map (kbd "C-c n c") 'hs-toggle-hiding)
(define-key c++-mode-map (kbd "C-c n l") 'hs-hide-level)
(define-key c++-mode-map (kbd "C-c n a") 'hs-show-all)

(define-key java-mode-map (kbd "C-c n c") 'hs-toggle-hiding)
(define-key java-mode-map (kbd "C-c n l") 'hs-hide-level)
(define-key java-mode-map (kbd "C-c n a") 'hs-show-all)

(use-package multiple-cursors
  :init
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
)

(provide 'setup-editing)
