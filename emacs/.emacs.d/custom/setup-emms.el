(use-package volume
  :ensure t
  :bind
  ("C-c m v" . volume))

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (require 'emms-player-vlc)
  ;;(emms-all) ; don't change this to values you see on stackoverflow questions if you expect emms to work
    (setq emms-seek-seconds 5)
    (setq emms-player-list '(emms-player-vlc))
    (setq emms-player-vlc-parameters '("--no-video" "--intf=rc"))
  :bind
    ("C-c m m" . emms)
    ("C-c m b" . emms-smart-browse)
    ("C-c m u" . emms-add-url)
    ("C-c h C-e p" . emms-add-playlist)
    ("<XF86AudioPrev>" . emms-previous)
    ("<XF86AudioNext>" . emms-next)
    ("<XF86AudioPlay>" . emms-pause)
    ("<XF86AudioStop>" . emms-stop)
    ("C-c m <left>" . emms-previous)
    ("C-c m <right>" . emms-next)
    ("C-c m <down>" . emms-pause)
    ("C-c m <up>" . emms-stop))

(defun emms-add-playlist-url ()
  "Adds all the videos of a youtube playlist to the emms player"
  (interactive)
  (defalias 'sc 'shell-command-to-string)
  (setq playlist (read-from-minibuffer "Play playlist URL: "
                                       nil  minibuffer-local-map nil))
  (setq yt-list (sc (format "~/.emacs.d/util/youtube-playlist.sh %s"
                            playlist)))
  (setq list (s-split "\n" yt-list))
  (loop for vid in list do
        (if (string= vid "")
            ()
          (emms-add-url vid))))

(global-set-key (kbd "C-c m p") 'emms-add-playlist-url)


(use-package helm-emms
  :init
  (setq emms-source-file-default-directory '"~/Musique/")

  (global-set-key (kbd "C-c h C-e f") 'emms-add-file))

(provide 'setup-emms)
