;; Add MELPA repository and initialise the package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Install use-package,in case it does not exist yet
;; The use-package software will install all other packages as required
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ESS configurationEmacs Speaks Statistics
(use-package ess
  :ensure t
)

;; Auto completion
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (global-company-mode t)
)

;; Setup mode-line
(setq column-number-mode t)
(require 'simple-modeline)
(simple-modeline-mode 1)

;; Parentheses
(use-package highlight-parentheses
  :ensure t
  :config
  (progn
    (highlight-parentheses-mode)
    (global-highlight-parentheses-mode))
  )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" default))
 '(package-selected-packages
   '(org-superstar magit tangotango-theme doom-themes simple-modeline ace-window julia-repl julia-mode vterm highlight-parentheses company ess use-package))
 '(simple-modeline-mode t)
 '(simple-modeline-segments
   '((simple-modeline-segment-modified simple-modeline-segment-buffer-name simple-modeline-segment-position)
     (simple-modeline-segment-vc simple-modeline-segment-process simple-modeline-segment-major-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Open in the current window - don't create a new window
(setq display-buffer-alist
             '((".*" (display-buffer-reuse-window display-buffer-same-window))))	

(setq display-buffer-reuse-frames t)

(setq pop-up-windows nil)

;; Julia-specific fix
(with-eval-after-load 'julia-repl
  (defun julia-repl ()
    "..."
    (interactive)
    (pop-to-buffer (julia-repl-inferior-buffer))))

;; Two space tabs
(setq ess-style 'RStudio)

;; R always opens with no save/restore
(setq inferior-R-args "--no-restore-history --no-save")

;; R setup
(require 'ess-site)

;; Define R setup function
(defun R_setup()
  "Setup R"
  (set-window-buffer (selected-window)
		     (file-name-nondirectory (car (last command-line-args))))
  (split-window-horizontally)
  (other-window 1)
  (vterm)
  (split-window-vertically)
  (R)
  (other-window -1)
  (global-set-key (kbd "M--") " <- ")
  )
  
;; Define path to Julia
(add-to-list 'load-path "/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia")
(require 'julia-repl)

;; Julia setup
(defun Julia_setup()
  "Setup julia"
  (set-window-buffer (selected-window)
		     (file-name-nondirectory (car (last command-line-args))))
  (split-window-horizontally)
  (other-window 1)
  (vterm)
  (split-window-vertically)
  (julia-repl)
  (other-window -1)
  (julia-repl-mode)
  )

;; Use virtual terminal
(use-package vterm
    :ensure t)

;; Arrow keys to move around panes
(windmove-default-keybindings)

;; Startup hooks for Julia and R
(add-hook 'emacs-startup-hook
	  (lambda()
	    (if (equal (file-name-extension (car (last command-line-args))) "R")
		(R_setup))
	    (if (equal (file-name-extension (car (last command-line-args))) "jl")
		(Julia_setup))
	    ))

;; All files backup in the same place
(setq backup-directory-alist '(("." . "~/.emacs_backups")))

;; Insert header to file
(defun header()
  "Insert header into file"
  (interactive)
  (progn
    (insert-file "~/.emacs.d/header")
    (re-search-forward "Date:")
    (insert (format-time-string " %Y-%m-%d"))))

;; ace window keybinding
(global-set-key (kbd "M-o") 'ace-window)

;; Set theme
(load-theme 'tangotango t)

;; Use superstar bullets
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-superstar-mode 1)
	    (org-superstar-configure-like-org-bullets)
	    (org-indent-mode t)
	    (visual-line-mode)
	    ))

;; Insert current date-time
(defun date-time()
  "Insert current date and time"
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))

