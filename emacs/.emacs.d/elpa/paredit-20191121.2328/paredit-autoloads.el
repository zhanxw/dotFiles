;;; paredit-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "paredit" "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el"
;;;;;;  "7f0d8daf49bb1aa4db5ce72cd8a9a365")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el

(autoload 'paredit-mode "paredit" "\
Minor mode for pseudo-structurally editing Lisp code.
With a prefix argument, enable Paredit Mode even if there are
  unbalanced parentheses in the buffer.
Paredit behaves badly if parentheses are unbalanced, so exercise
  caution when forcing Paredit Mode to be enabled, and consider
  fixing unbalanced parentheses instead.
\\<paredit-mode-map>

\(fn &optional ARG)" t nil)

(autoload 'enable-paredit-mode "paredit" "\
Turn on pseudo-structural editing of Lisp code.

\(fn)" t nil)

;;;### (autoloads "actual autoloads are elsewhere" "paredit" "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "paredit" '("paredit-" "?\\" "disable-paredit-mode")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/paredit-20191121.2328/paredit.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; paredit-autoloads.el ends here
