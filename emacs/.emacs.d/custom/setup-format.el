;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;   __                            _    ;;
;;  / _| ___  _ __ _ __ ___   __ _| |_  ;;
;; | |_ / _ \| '__| '_ ` _ \ / _` | __| ;;
;; |  _| (_) | |  | | | | | | (_| | |_  ;;
;; |_|  \___/|_|  |_| |_| |_|\__,_|\__| ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set hexl mode if binary (unless its a .pdf file)
(defun buffer-binary-p (&optional buffer)
  "Return whether BUFFER or the current buffer is binary.

A binary buffer is defined as containing at least on null byte.

Returns either nil, or the position of the first null byte."
  (with-current-buffer (or buffer (current-buffer))
    (save-excursion
      (goto-char (point-min))
      (search-forward (string ?\x00) nil t 1)
      )
    )
  )

(defun hexl-if-binary ()
  "If `hexl-mode' is not already active, and the current buffer
is binary, activate `hexl-mode'."
  (interactive)
  (unless (or(eq major-mode 'hexl-mode)
             (and (stringp buffer-file-name)
                  (or(string-match "\\.pdf\\'" buffer-file-name)(string-match "\\.JPG\\'" buffer-file-name)(string-match "\\.png\\'" buffer-file-name) )))
    (when (buffer-binary-p)
      (hexl-mode))))

(add-hook 'find-file-hooks 'hexl-if-binary)

(provide 'setup-format)
