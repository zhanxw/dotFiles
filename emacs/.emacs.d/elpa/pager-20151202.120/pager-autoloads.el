;;; pager-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "pager" "../../../../../.emacs.d/elpa/pager-20151202.120/pager.el"
;;;;;;  "ca6dda6cda1f853b31f01e8251bd3040")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/pager-20151202.120/pager.el

(autoload 'pager-page-down "pager" "\
Like scroll-up, but moves a fixed amount of lines (fixed relative the
`window-height') so that pager-page-up moves back to the same line.

\(fn)" t nil)

(autoload 'pager-page-up "pager" "\
Like scroll-down, but moves a fixed amount of lines (fixed relative the
`window-height') so that pager-page-down moves back to the same line.

\(fn)" t nil)

(autoload 'pager-row-up "pager" "\
Move point to previous line while scrolling screen down one line.
The effect is that the cursor stays in the same position on the screen.

\(fn)" t nil)

(autoload 'pager-row-down "pager" "\
Move point to next line while scrolling screen up one line.
The effect is that the cursor stays in the same position on the screen.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "pager" "../../../../../.emacs.d/elpa/pager-20151202.120/pager.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/pager-20151202.120/pager.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "pager" '("pg-" "pager-" "row-")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/pager-20151202.120/pager-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/pager-20151202.120/pager.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; pager-autoloads.el ends here
