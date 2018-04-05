;;; ggtags-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags"
;;;;;;  "ggtags.el" "df836b4079e52e53f7931f2d99539375")
;;; Generated autoloads from ggtags.el

(autoload 'ggtags-find-project "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags" "\


\(fn)" nil nil)

(autoload 'ggtags-find-tag-dwim "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags" "\
Find NAME by context.
If point is at a definition tag, find references, and vice versa.
If point is at a line that matches `ggtags-include-pattern', find
the include file instead.

When called interactively with a prefix arg, always find
definition tags.

\(fn NAME &optional WHAT)" t nil)

(autoload 'ggtags-mode "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags" "\
Toggle Ggtags mode on or off.
With a prefix argument ARG, enable Ggtags mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil, and toggle it if ARG is `toggle'.
\\{ggtags-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'ggtags-build-imenu-index "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags" "\
A function suitable for `imenu-create-index-function'.

\(fn)" nil nil)

(autoload 'ggtags-try-complete-tag "../../../dotFiles/emacs/.emacs.d/elpa/ggtags-20170711.1806/ggtags" "\
A function suitable for `hippie-expand-try-functions-list'.

\(fn OLD)" nil nil)

;;;***

;;;### (autoloads nil "ggtags" "../../../../../.emacs.d/elpa/ggtags-20170711.1806/ggtags.el"
;;;;;;  "df836b4079e52e53f7931f2d99539375")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/ggtags-20170711.1806/ggtags.el

(autoload 'ggtags-find-project "ggtags" "\


\(fn)" nil nil)

(autoload 'ggtags-find-tag-dwim "ggtags" "\
Find NAME by context.
If point is at a definition tag, find references, and vice versa.
If point is at a line that matches `ggtags-include-pattern', find
the include file instead.

When called interactively with a prefix arg, always find
definition tags.

\(fn NAME &optional WHAT)" t nil)

(autoload 'ggtags-mode "ggtags" "\
Toggle Ggtags mode on or off.
With a prefix argument ARG, enable Ggtags mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil, and toggle it if ARG is `toggle'.
\\{ggtags-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'ggtags-build-imenu-index "ggtags" "\
A function suitable for `imenu-create-index-function'.

\(fn)" nil nil)

(autoload 'ggtags-try-complete-tag "ggtags" "\
A function suitable for `hippie-expand-try-functions-list'.

\(fn OLD)" nil nil)

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/ggtags-20170711.1806/ggtags-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/ggtags-20170711.1806/ggtags-pkg.el"
;;;;;;  "../../../../../.emacs.d/elpa/ggtags-20170711.1806/ggtags.el"
;;;;;;  "ggtags.el") (22887 10900 970628 309000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; ggtags-autoloads.el ends here
