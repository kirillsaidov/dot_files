(setq custom-file "~/.emacs.custom.el")

;; Tab settings
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq c-default-style "bsd"
      c-basic-offset 4)

;; Basic settings about UI & UX
(menu-bar-mode 0)
(tool-bar-mode 0)
(global-display-line-numbers-mode 1)
(ido-mode 1)
(ido-everywhere 1)

;; My functions
(require 'shell)
(defun my/new-shell ()
  "Open a new shell buffer."
  (interactive)
  (let ((buf (generate-new-buffer "*shell*")))
    (shell buf)))

(require 'term)
(defun my/new-term ()
  "Open a new term buffer running your default shell."
  (interactive)
  (let* ((shell (or explicit-shell-file-name
                    (getenv "SHELL")
                    "/bin/bash"))
         (term-buffer (generate-new-buffer-name "*term*")))
    (term shell)))

;; Bind custom keys
(global-set-key (kbd "C-x 9") 'compile)
(global-set-key (kbd "C-,") 'duplicate-line)
(global-set-key (kbd "C-c s") 'my/new-shell)
(global-set-key (kbd "C-c t") 'my/new-term)

;; Ansi term colors
(require 'ansi-color)

(defun compilation-ansi-colorize ()
  "Apply ANSI colors to the current compilation buffer output."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook 'compilation-ansi-colorize)

;; Install packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Load custom file
(load-file custom-file)
