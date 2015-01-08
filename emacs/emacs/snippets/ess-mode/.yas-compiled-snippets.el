;;; Compiled snippets and support files for `ess-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'ess-mode
		     '(("args.yasnippet" "default.args <- c($0)\nargs <- commandArgs(trailingOnly = TRUE)\nif (length(args) == 0) {\n        args <- default.args\n}\n" "args" nil nil nil nil nil nil)
		       ("getopt" "library(getopt)\nGETOPT_ARG_NONE <- 0\nGETOPT_ARG_REQUIRED <- 1\nGETOPT_ARG_OPTIONAL <- 2\n\nspec = matrix(c(\n    'input', 'i', GETOPT_ARG_REQUIRED, \"character\",$0\n    ), byrow = TRUE, ncol = 4)\nopt = getopt(spec);\n\n\n" "getopt" nil nil nil nil nil nil)
		       ("myopt.yasnippet" "options(stringsAsFactors = FALSE)\n" "myopt" nil nil nil nil nil nil)
		       ("rm.yasnippet" "rm(list=ls())\n" "rm" nil nil nil nil nil nil)
		       ("try" "tryResult <- try({$1},silent=TRUE)\nif(class(tryResult)=='try-error') {\n  $0\n}" "try" nil nil nil nil nil nil)))


;;; Do not edit! File generated at Thu Dec 11 22:24:05 2014
