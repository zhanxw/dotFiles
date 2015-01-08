;; r-utils.el		Useful R functions and keybindings to use in iESS.
;; Time-stamp: <Wed 08 Dec 2004 14:46:54 CST>
;; Copyright (c) 2004 Sebastian Luque

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

;; Sebastian Luque is
;; 	<sluque@mun.ca>
;;   Unstable mailing address:
;; 	Fisheries and Oceans Canada
;; 	501 University Crescent
;; 	Winnipeg, MB R3T 2N6
;; 	Canada

;; Description and installation:

;; This library attempts to provide key bindings for performing basic R
;; functions, such as loading and managing packages, as well as object
;; manipulation. To install, put the file in an appropriate place depending on
;; your system. Load the library with the method you prefer (e.g. M-x
;; load-file), but the easiest is probably to a) make sure your load-path
;; variable includes the directory where r-utils.el resides, and b) include a
;; (require 'r-utils) statement in your .emacs file.

;; Usage:

;; Once R is started with M-x R, you should have the key bindings defined at
;; the end of this file working in your iESS process buffers. One of the
;; functions is just a wrapper for the ess-rdired function from Stephen
;; Eglen's ess-rdired.el. Simply type the desired key binding.

;; Acknowledgements:

;; I could not have written this file without using ideas from many others,
;; especially when learning a little lisp during spare time. I am grateful to
;; John Fox for having written his init.el file for XEmacs, which motivated me
;; to write this Emacs alternative. I wanted to add some object management
;; comforts and came across Stephen Eglen's ess-rdired.el, which provides
;; exactly that. In fact, r-utils uses a *lot* of ideas from ess-rdired.el, so
;; I thank Stephen and the ESS development group for making life with R so
;; much easier.

;; Note: I have only tested this on my own system: GNU Emacs 21.3.1
;; (i386-pc-linux-gnu, X toolkit, Xaw3d scroll bars) of 2004-10-16 on raven,
;; modified by Debian. Comments and suggestions for improvement and
;; interoperability are *very* welcome.

;; Todo:

;; * Learn how essa.sas.el deals with key bindings, as suggested by Anthony
;; Rossini.

;; should 'provide' go here or at the end as some files do?
(provide 'r-utils)

;; autoloads and requires. What else should be 'required' here?
(autoload 'ess-rdired "ess-rdired" "View *R* objects in a dired-like buffer." t)
(require 'ess-site)

(defvar r-utils-buf "*R temp*"
  "Name of temporary R buffer.")

(defvar r-utils-mode-map nil
  "Keymap for the *R temp* buffer.")

(if r-utils-mode-map
    ()
  (setq r-utils-mode-map (make-sparse-keymap))
  (define-key r-utils-mode-map "l" 'r-utils-loadpkg)
  (define-key r-utils-mode-map "i" 'r-utils-mark-install)
  (define-key r-utils-mode-map "I" 'r-utils-install)
  (define-key r-utils-mode-map "u" 'r-utils-unmark)
  (define-key r-utils-mode-map "q" 'r-utils-quit)
  (define-key r-utils-mode-map "?" 'r-utils-help))

(defun r-utils-mode ()
  "Major mode for output from r-utils-localpkgs and r-utils-repospkgs.
Useful bindings to handle package loading and installing.
\\{r-utils-mode-map}"
  (kill-all-local-variables)
  (use-local-map r-utils-mode-map)
  (setq major-mode 'r-utils-mode)
  (setq mode-name (concat "R utils " ess-local-process-name)))

(defun r-utils-localpkgs ()
  "List all packages in all libraries."
  (interactive)
  (if (get-buffer r-utils-buf)
      (progn
	(set-buffer r-utils-buf)
	(setq buffer-read-only nil)))
  (ess-execute
   "writeLines(paste('  ', sort(.packages(all.available=TRUE)), sep=''))"
   nil
   (substring r-utils-buf 1 (- (length r-utils-buf) 1)))
  (pop-to-buffer r-utils-buf)
  (save-excursion
    (beginning-of-line) (open-line 1)
    (insert "**Available packages in all local R libraries**"))
  (setq buffer-read-only t)
  (r-utils-mode)
  (if (featurep 'fit-frame)
      (fit-frame)))

(defun r-utils-namepkg ()
  "Return name of the package on current line."
  (save-excursion
    (beginning-of-line)
    (if (looking-at "*")
	nil
      (forward-char 2)
      (let (beg)
	(setq beg (point))
	(end-of-line) ;assume package names are separated by newlines.
	(buffer-substring-no-properties beg (point))))))

(defun r-utils-loadpkg ()
  "Load package from a library."
  (interactive)
  (let ((oklocal nil))
    (save-excursion
      (goto-char (point-min))
      (if (search-forward "libraries**" nil t)
	  (setq oklocal t)))
    (if oklocal
	(progn
	  (setq pkg (r-utils-namepkg))
	  (ess-execute (concat "library('" pkg "', character.only=TRUE)")
		       'buffer))
      nil)))

(defun r-utils-repospkgs (repos)
  "List packages from the REPOS repository (CRAN or BIOC)."
  (interactive "sRepository to list packages from: ")
  (if (get-buffer r-utils-buf)
      (progn
	(set-buffer r-utils-buf)
	(setq buffer-read-only nil)))
  (ess-execute (concat
		"writeLines(paste('  \"', rownames(CRAN.packages(getOption('"
		repos "'))), '\"', sep=''))")
	       nil
	       (substring r-utils-buf 1 (- (length r-utils-buf) 1)))
  (pop-to-buffer r-utils-buf)
  (save-excursion
    (kill-line 5)
    (insert (concat "**" repos " packages available to install**")))
  (setq buffer-read-only t)
  (r-utils-mode)
  (if (featurep 'fit-frame)
      (fit-frame)))

(defun r-utils-mark-install (arg)
  "Mark the current package for installing.
ARG lines to mark is passed to r-utils-mark."
  (interactive "p")
  ;; if this is not an install package buffer return nil.
  (let ((okmark nil))
    (save-excursion
      (goto-char (point-min))
      (if (search-forward "install**" nil t)
	  (setq okmark t)))
    (if okmark
	(r-utils-mark "I" arg)
      nil)))

(defun r-utils-unmark (arg)
  "Unmark the packages, passing ARG lines to unmark to r-utils-mark."
  (interactive "p")
  (r-utils-mark " " arg))

;; The next two functions almost verbatim from ess-rdired.el.
(defun r-utils-mark (mark-char arg)
  "Mark package on current (or next ARG lines) line using MARK-CHAR."
  ;; If we are on first line, mark all lines.
  (let ((buffer-read-only nil)
	move)
    (if (eq (point-min)
	    (save-excursion (beginning-of-line) (point)))
	(progn
	  ;; we are on first line, so make a note of point, and count
	  ;; how many objects we want to delete.  Then at end of defun,
	  ;; restore point.
	  (setq move (point))
	  (forward-line 1)
	  (setq arg (count-lines (point) (point-max)))))
    (while (and (> arg 0) (not (eobp)))
      (setq arg (1- arg))
      (beginning-of-line)
      (progn
	(insert mark-char)
	(delete-char 1)
	(forward-line 1)))
    (if move
	(goto-char move))))

(defun r-utils-install ()
  "Install all packages flagged for installation, and return to the iESS buffer.
User is asked for confirmation."
  (interactive)
  (let ((inst "install.packages(c(")
	(count 0))
    (save-excursion
      (goto-line 2)
      ;; as long as number of lines between buffer start and point is smaller
      ;; than the total number of lines in buffer, go to the beginning of the
      ;; line, check if line is flagged, and if it is, advance the counter by
      ;; one, create the root of install function, add the package name,
      ;; insert a comma, and move forward a line.
      (while (< (count-lines (point-min) (point))
		(count-lines (point-min) (point-max)))
	(beginning-of-line)
	(if (looking-at "^I ")
	    (setq count (1+ count)
		  inst (concat inst (r-utils-namepkg) ", " )))
	(forward-line 1)))
    (if (> count 0)			;found packages to install
	(progn
	  ;; Fix the install function created before and close it.
	  (setq inst (concat
		      (substring inst 0 (- (length inst) 2)) "))"))
	  ;;
	  (if (yes-or-no-p (format "Install %d %s " count
				   (if (> count 1) "packages" "package")))
	      (progn
		(ess-execute inst 'buffer)
		(r-utils-quit))))
      ;; else nothing to install
      (message "no packages flagged to install"))))

(defun r-utils-updatepkgs (repos)
  "Update packages from REPOS."
  (interactive "srepository to update from: ")
  (ess-execute (concat "update.packages(CRAN=getOption('"
		       repos "'))") 'buffer))

(defun r-utils-apropos (string)
  "Search for STRING using apropos."
  (interactive "sApropos search for? ")
  (if (get-buffer r-utils-buf)
      (progn
	(set-buffer r-utils-buf)
	(setq buffer-read-only nil)))
  (ess-execute (concat "apropos('" string "')")
	       nil
	       (substring r-utils-buf 1 (- (length r-utils-buf) 1)))
  (pop-to-buffer r-utils-buf)
  (setq buffer-read-only t)
  (r-utils-mode)
  (if (featurep 'fit-frame)
      (fit-frame)))

(defun r-utils-rmall ()
  "Remove all R objects."
  (interactive)
  (if (y-or-n-p "Delete all objects? ")
      (ess-execute "rm(list=ls())" 'buffer)))

(defun r-utils-objs ()
  "Manipulate R objects; wrapper for ess-rdired."
  (interactive)
  (ess-rdired)
  (if (featurep 'fit-frame)
      (fit-frame)))

(defun r-utils-loadwkspc (file)
  "Load workspace FILE into R."
  (interactive "fFile with workspace to load: ")
  (ess-execute (concat "load('" file "')") 'buffer))

(defun r-utils-savewkspc (file)
  "Save FILE workspace.
File extension not required."
  (interactive "FSave workspace to file (no extension): ")
  (ess-execute (concat "save.image('" file ".RData')") 'buffer))

(defun r-utils-chgdir (dir)
  "Change to DIR working directory."
  (interactive "DChange directory to: ")
  (ess-execute (concat "setwd('" dir "')") 'buffer))

(defun r-utils-quit ()
  "Kill the r-utils buffer and return to the iESS buffer."
  (interactive)
  (ess-switch-to-end-of-ESS)
  (kill-buffer r-utils-buf))

;; (experimental) navigating html documentation with w3m.
;; Maybe create a customizable variable to switch it on?
(defun r-utils-htmldocs ()
  "Use w3m to navigate R html documentation.
Documentation is produced by help.start()."
  (interactive)
  (let ((rhtml ".rutils.help.start <- function () {.Script('sh', 'help-links.sh',
paste(tempdir(), paste(.libPaths(), collapse = ' '))); make.packages.html();
url <- paste('file://', tempdir(), '/.R/doc/html/index.html', sep = '');
url}; .rutils.help.start()\n")
	(tmpbuf (get-buffer-create "**r-utils-mode**")))
    (ess-command rhtml tmpbuf)
    (set-buffer tmpbuf)
    (setq url (buffer-substring (+ 18 (point-min)) (- (point-max) 2)))
    (w3m-goto-url-new-session (concat "file:" url))
    (kill-buffer tmpbuf)))

(defun r-utils-help ()
  "Show help on `r-utils-mode'."
  (interactive)
  (describe-function 'r-utils-mode))

;; Customizable variable to allow r-utils-keys to activate default key bindings.
;; Suggested by Rich Heiberger. Not sure how to implement this.
(defcustom r-utils-keys nil
  "Non-nil means activate R-utils keybindings and menu."
  :group 'ess-r
  :type 'boolean)

(defun r-utils-keys ()
  (interactive)
  (if r-utils-keys
      (progn
	;; Some key bindings suggested by Patrick Dreschler.
	(define-key inferior-ess-mode-map [(control c) (c) (l)]
	  'r-utils-localpkgs)
	(define-key inferior-ess-mode-map [(control c) (c) (r)]
	  'r-utils-repospkgs)
	(define-key inferior-ess-mode-map [(control c) (c) (u)]
	  'r-utils-updatepkgs)
	(define-key inferior-ess-mode-map [(control c) (c) (a)]
	  'r-utils-apropos)
	(define-key inferior-ess-mode-map [(control c) (c) (m)]
	  'r-utils-rmall)
	(define-key inferior-ess-mode-map [(control c) (c) (o)]
	  'r-utils-objs)
	(define-key inferior-ess-mode-map [(control c) (c) (w)]
	  'r-utils-loadwkspc)
	(define-key inferior-ess-mode-map [(control c) (c) (s)]
	  'r-utils-savewkspc)
	(define-key inferior-ess-mode-map [(control c) (c) (d)]
	  'r-utils-chgdir)
	;; Menu, as suggested by Martin Maechler.
	(define-key-after
	  (lookup-key inferior-ess-mode-map [menu-bar iESS])
	  [sep]
	  '("--") 'ess-submit-bug-report)
	(define-key-after
	  (lookup-key inferior-ess-mode-map [menu-bar iESS])
	  [r-utils]
	  (cons "R-utils" (make-sparse-keymap "R-utils"))
	  'ess-submit-bug-report)
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils htmldocs]
	  '("Browse HTML" . r-utils-htmldocs))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils apropos]
	  '("Apropos" . r-utils-apropos))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils chgdir]
	  '("Change directory" . r-utils-chgdir))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils savewkspc]
	  '("Save workspace" . r-utils-savewkspc))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils loadwkspc]
	  '("Load workspace" . r-utils-loadwkspc))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils updatepkgs]
	  '("Update packages" . r-utils-updatepkgs))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils repospkgs]
	  '("Repositories" . r-utils-repospkgs))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils localpkgs]
	  '("Local packages" . r-utils-localpkgs))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils rmall]
	  '("Remove objects" . r-utils-rmall))
	(define-key inferior-ess-mode-map [menu-bar iESS r-utils objs]
	  '("Manage objects" . r-utils-objs)))))

;; I don't know if this should be here or let the user do it, e.g., in .emacs.
(add-hook 'inferior-ess-mode-hook
	  'r-utils-keys)
