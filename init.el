(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))


;; add modules path
(add-to-list 'load-path "~/.emacs.d/custom/")
(mapc 'load (directory-files "~/.emacs.d/custom" t ".*\.el"))


;; general appearance
(blink-cursor-mode -1)
(setq inhibit-startup-screen 1)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; ido-mode
(ido-mode 1)

;; smartparens
(smartparens-mode 1)

;; highligth numbers
(add-hook 'prog-mode-hook 'highlight-numbers-mode)

;; highlight matching parantheses
(setq show-paren-delay 0.1)
(show-paren-mode 1)

;; linum mode
(global-linum-mode 1)
(setq-default linum-format "%d ")

;; column numbers
(column-number-mode 1)


;; UTF-8 EDITING
;;
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)


;; MOVE TO BEGINNING OF LINE/TEXT
;;
;; rebind C-a to move to the beginning of text instead of beginning of line
(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first. If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))
;;
(global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)


;; delete selection
(delete-selection-mode)

;; show trailing whitespace
(add-hook 'prog-mode-hook
	  (lambda ()
	    (interactive)
	    (setq show-trailing-whitespace 1)))


;; easy window navigation
(windmove-default-keybindings)


;; easy buffer navigation
(defun bufmove-default-keybindings (&optional modifier)
  "Set up keybindings for switching between buffers in current window."
  (interactive)
  (unless modifier (setq modifier 'control))
  (global-set-key (vector (list modifier 'left)) 'previous-buffer)
  (global-set-key (vector (list modifier 'right)) 'next-buffer)
  (global-set-key (kbd "C-<left>") 'previous-buffer)
  (global-set-key (kbd "C-<right>") 'next-buffer)
  )

(bufmove-default-keybindings)


;; yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)


;; better scrolling through file
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position nil)

;; newline and indent
(global-set-key (kbd "RET") 'newline-and-indent)

;; clean aindent
(add-hook 'prog-mode-hook 'clean-aindent-mode)


;; shell-pop
(require 'shell-pop)
(global-set-key (kbd "<f2>") 'shell-pop)


;; handle auto-save files
;; BACKUP FILES
;;
;; define a backups directory and generate _a lot_ of backups!
;; (which is a really good thing)
(defvar backup-directory "~/.backups")
(if (not (file-exists-p backup-directory))
        (make-directory backup-directory t))
;;
(setq
 make-backup-files t    ; backup a file the first time it is saved
 backup-directory-alist `((".*" . ,backup-directory)) ; save files in chosen backup folder
 backup-by-copying t    ; copy the current file into backup directory
 version-control t      ; version numbers for backup files
 delete-old-versions t  ; delete unnecessary versions
 kept-old-versions 6    ; oldest versions to keep when a new numbered backup is made (default: 2)
 kept-new-versions 9    ; newest versions to keep when a new numbered backup is made (default: 2)
 auto-save-default t    ; auto-save every buffer that visits a file
 auto-save-timeout 40   ; number of seconds idle time before auto-save (default: 30)
 auto-save-interval 400 ; number of keystrokes between auto-saves (default: 300)
 )

