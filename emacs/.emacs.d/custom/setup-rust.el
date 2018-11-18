(use-package rust-mode)
(use-package flymake-rust)
(use-package cargo
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

;; $ rustup component add rust-src
;; $ cargo install racer

(provide 'setup-rust)
