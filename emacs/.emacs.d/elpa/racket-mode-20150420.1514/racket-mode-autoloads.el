;;; racket-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "racket-edit" "racket-edit.el" (21813 52183
;;;;;;  193218 773000))
;;; Generated autoloads from racket-edit.el

(add-to-list 'hs-special-modes-alist '(racket-mode "(" ")" ";" nil nil))

;;;***

;;;### (autoloads nil "racket-mode" "racket-mode.el" (21813 52183
;;;;;;  123215 592000))
;;; Generated autoloads from racket-mode.el

(autoload 'racket-mode "racket-mode" "\
Major mode for editing Racket.
\\{racket-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.rkt[dl]?\\'" . racket-mode))

(modify-coding-system-alist 'file "\\.rkt[dl]?\\'" 'utf-8)

(add-to-list 'interpreter-mode-alist '("racket" . racket-mode))

;;;***

;;;### (autoloads nil "racket-repl" "racket-repl.el" (21813 52183
;;;;;;  183218 318000))
;;; Generated autoloads from racket-repl.el

(autoload 'racket-repl "racket-repl" "\
Run the Racket REPL and display its buffer in some window.

If the Racket process is not already running, it is started.

If NOSELECT is not nil, does not select the REPL
window (preserves the originally selected window).

Commands that don't want the REPL to be displayed can instead use
`racket--repl-ensure-buffer-and-process'.

\(fn &optional NOSELECT)" t nil)

;;;***

;;;### (autoloads nil nil ("racket-collection.el" "racket-common.el"
;;;;;;  "racket-complete.el" "racket-custom.el" "racket-font-lock.el"
;;;;;;  "racket-indent.el" "racket-keywords-and-builtins.el" "racket-make-doc.el"
;;;;;;  "racket-mode-pkg.el" "racket-profile.el" "racket-tests.el"
;;;;;;  "racket-util.el") (21813 52183 225560 464000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; racket-mode-autoloads.el ends here
