;;; jedi-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "jedi" "../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi.el"
;;;;;;  "8554b1831090b0af7e6b9213bffcc4cf")
;;; Generated autoloads from ../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi.el

(autoload 'jedi:ac-setup "jedi" "\
Add Jedi AC sources to `ac-sources'.

If auto-completion is all you need, you can call this function instead
of `jedi:setup', like this::

   (add-hook 'python-mode-hook 'jedi:ac-setup)

Note that this function calls `auto-complete-mode' if it is not
already enabled, for people who don't call `global-auto-complete-mode'
in their Emacs configuration.

\(fn)" t nil)

(autoload 'jedi:complete "jedi" "\
Complete code at point.

\(fn &key (EXPAND ac-expand-on-auto-complete))" t nil)

(autoload 'jedi:auto-complete-mode "jedi" "\


\(fn)" nil nil)

(setq jedi:setup-function #'jedi:ac-setup jedi:mode-function #'jedi:auto-complete-mode)

;;;### (autoloads "actual autoloads are elsewhere" "jedi" "../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from ../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "jedi" '("jedi:")))

;;;***

;;;***

;;;### (autoloads nil nil ("../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi-autoloads.el"
;;;;;;  "../../../../../.emacs.d/elpa/jedi-20191011.1750/jedi.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; jedi-autoloads.el ends here
