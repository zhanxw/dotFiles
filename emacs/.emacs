(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
;; Within Emacs, use M-x list-packages to list all packages which will
;; automatically refresh the archive contents. Afterwards use U to mark all
;; upgradable packages to be upgraded, and x to actually perform the new updates.
;; Emacs will then fetch and install all upgrades, and ask you to whether to
;; remove the old, obsolete versions afterwards.
(package-initialize)

(setq vc-follow-symlinks t)

;; ;; config cedet first, so to avoid max-lisp-eval-depth error
;; ;; from: http://emacser.com/cedet.htm
;;; (load-file "~/emacsesscedet/common/cedet.el")
;; ;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;; ;; (semantic-load-enable-guady-code-helpers)
;; ;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)
;; ;; use M-x eassist-switch-h-cpp => switch between .cpp and .h
;; (require 'semantic-c nil 'noerror)
;; (setq eassist-header-switches
;;       '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
;;         ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
;;         ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
;;         ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
;;         ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
;;         ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
;;         ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
;;         ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
;;         ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
;;         ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
;;         ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
;;         ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
;;         ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
;;         ("c" . ("h"))
;;         ("m" . ("h"))
;;         ("mm" . ("h"))))

(global-font-lock-mode t)
(set-face-foreground 'font-lock-comment-face "red")
(set-face-foreground 'font-lock-comment-delimiter-face "red")
(transient-mark-mode t)
(column-number-mode t)

;; my old indent style
;; (setq standard-indent 2)
;; (require 'cc-mode)
;; (c-set-offset 'substatement-open 0)
;; (c-set-offset (quote substatement) 2 nil)
;; (c-set-offset 'defun-block-intro 2)
;; (c-set-offset 'statement-block-intro 2)
;; (c-set-offset 'statement-case-intro 2)
;; (setq standard-indent 2)

;; To conform to Karma code standard
;; we use K&R style and 4 as indent length.
;;(c-set-offset 'substatement-open 0)

;; Emacs Load Path
(setq load-path (cons "~/emacs" load-path))

;; sr-speedbar
(require 'sr-speedbar)

(require 'cc-mode)
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(defun my-build-tab-stop-list (width)
  (let ((num-tab-stops (/ 80 width))
        (counter 1)
        (ls nil))
    (while (<= counter num-tab-stops)
      (setq ls (cons (* width counter) ls))
      (setq counter (1+ counter)))
    (set (make-local-variable 'tab-stop-list) (nreverse ls))))
;; #if ... #endif part will become comment in font lock
;; taken from http://stackoverflow.com/questions/4549015/in-c-c-mode-in-emacs-change-face-of-code-in-if-0-endif-block-to-comment-fa
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)
(defun my-c-mode-common-hook ()
  ;; (c-set-style "k&r")
  ;; (setq tab-width 4) ;; change this to taste, this is what K&R uses :)
  (my-build-tab-stop-list tab-width)
  (setq c-basic-offset tab-width)
  (setq indent-tabs-mode nil) ;; force only spaces for indentation
  (local-set-key "\C-o" 'ff-get-other-file)
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c++-mode-common-hook 'my-c-mode-common-hook)



;; maximum column number in fill-mode is 60
(setq default-fill-column 60)

;; Generally, to bind a key
;;    1. M-x global-set-key RET 交互式的绑定的键。
;;    2. C-x Esc Esc 调出上一条$A-Y$AN484TSC|An$AN!!#

(global-set-key [f8] 'compile)


;; Match "%" accordingly
;; (global-set-key "%" 'goto-match-paren)
;; (defun goto-match-paren (arg)
;;   "Go to the matching parenthesis if on parenthesis, otherwise insert .
;; vi style of  jumping to matching brace."
;;   (interactive "p")
;;   (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
;;         ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
;;         (t (self-insert-command (or arg 1)))))

(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(")
         (forward-list 1)
         (backward-char 1) )
        ((looking-at "\\s\)")
         (let ((old (point)))
           (forward-char 1)
           (backward-list 1)
           (let ((new (point)))
             (cond ((= (- old new) 2)
                    (forward-char 1)
                    (if (= (- old new) 2)
                        (forward-char 1))
                    (self-insert-command (or arg 1)))
                   (t (goto-char new))))))
        (t (self-insert-command (or arg 1)))))

;; Begin to scroll when there are 3 lines.
(setq scroll-margin 3
      scroll-conservatively 10000)

;;swbuff-y.el, swbuff.el
;;Buffer switching with C-tab/C-S-tab.
;;You can find swbuff-y.el on EmacsW32 web site.
;;You also needs swbuff.el which you can find on http://www.EmacsWiki.org/.
;; (add-to-list 'load-path "~/emacs/EmacsW32")
;; (require 'swbuff-y)
;; (swbuff-y-mode t)
;; (require 'swbuff)
;; (swbuff-mode t)

;; ansi-color
;; (load "~/emacs/ansi-color.el")
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; ESS
(add-to-list 'load-path "~/emacs/third/ess/lisp")
(require 'ess-site)

;; customize ESS
;; http://www.kieranhealy.org/blog/archives/2009/10/12/make-shift-enter-do-a-lot-in-ess/
;; Adapted with one minor change from Felipe Salazar at
;; http://www.emacswiki.org/emacs/EmacsSpeaksStatistics
(setq ess-ask-for-ess-directory nil)
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(defun my-ess-start-R ()
  (interactive)
  (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
      (progn
        (delete-other-windows)
        (setq w1 (selected-window))
        (setq w1name (buffer-name))
        (setq w2 (split-window w1 nil t))
        (R)
        (set-window-buffer w2 "*R*")
        (set-window-buffer w1 w1name))))
(defun my-ess-eval ()
  (interactive)
  (my-ess-start-R)
  (if (and transient-mark-mode mark-active)
      (call-interactively 'ess-eval-region)
    (call-interactively 'ess-eval-line-and-step)))
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))
;; also bind C-return,
;; See http://www.nongnu.org/emacs-tiny-tools/keybindings/ 3.1
;; for why we cannot Shift-Return in terminal mode emacs
(add-hook 'ess-mode-hook
          '(lambda()
             (local-set-key [C-j] 'my-ess-eval)))
(add-hook 'inferior-ess-mode-hook
          '(lambda()
             (local-set-key [C-up] 'comint-previous-input)
             (local-set-key [C-down] 'comint-next-input)))
(add-hook 'Rnw-mode-hook
          '(lambda()
             (local-set-key [(shift return)] 'my-ess-eval)))

;; another set of shortcuts
;; does not work, maybe KEY part "C-j" does not work...
;; (define-key ess-mode-map "C-j" 'my-ess-eval)
;; (define-key ess-mode-map "C-M-j" 'ess-eval-function-or-paragraph-and-step)
;; working version
(define-key ess-mode-map [(control j)] 'my-ess-eval)
(define-key ess-mode-map [(control meta j)] 'ess-eval-function-or-paragraph-and-step)

;; disable auto convert _ to <-
(ess-toggle-underscore nil)
;; align '#', '##' the same way
(setq ess-fancy-comments nil)

                                        ; Enable which-func
(which-func-mode)
(add-to-list 'which-func-modes 'ess-mode)
                                        ; Modeline format
(setq-default mode-line-format
              '("L%l C%c %b"
                global-mode-string " (" mode-name minor-mode-alist "%n)"
                (which-func-mode (" " which-func-format ""))))
(require 'r-utils)

;; set R program for ESS
;; (setq inferior-R-program-name "~/software/Rmkl/bin/R")
;; (setq inferior-R-program-name "/usr/bin/R")
;; (setq inferior-R-program-name "~/bin/R")

;; for switch buffer use
(global-set-key "\C-x\C-b" 'bs-show)    ;; or another key
(global-set-key "\M-p"  'bs-cycle-previous)
(global-set-key "\M-n"  'bs-cycle-next)

;; set ess coding style
;; http://stackoverflow.com/questions/12805873/changing-indentation-in-emacs-ess
(add-hook 'ess-mode-hook
          (lambda ()
            (ess-set-style 'DEFAULT 'quiet)
            ;; Because
            ;;                                 DEF GNU BSD K&R  C++
            ;; ess-indent-level                  2   2   8   5  4
            ;; ess-continued-statement-offset    2   2   8   5  4
            ;; ess-brace-offset                  0   0  -8  -5 -4
            ;; ess-arg-function-offset           2   4   0   0  0
            ;; ess-expression-offset             4   2   8   5  4
            ;; ess-else-offset                   0   0   0   0  0
            ;; ess-close-brace-offset            0   0   0   0  0
            (add-hook 'local-write-file-hooks
                      (lambda ()
                        (ess-nuke-trailing-whitespace)))))
;; (setq ess-nuke-trailing-whitespace-p 'ask)
;; or even
(setq ess-nuke-trailing-whitespace-p t)
 

;; how to bind keys in Emacs:
;; 1. M-x global-set-key
;; 2. C-Esc Esc  to get previous command
;;

;; My personal keybindings
;; C-;   change to other window
(global-set-key (quote [67108923]) (quote other-window))
(if window-system
    (windmove-default-keybindings 'meta)
  (progn
    (global-set-key (quote [27 left])  'windmove-left)
    (global-set-key (quote [27 up]) 'windmove-up)
    (global-set-key (quote [27 right]) 'windmove-right)
    (global-set-key (quote [27 down]) 'windmove-down)))
;; C-c c   comment-region
(global-set-key "c" (quote comment-region))
;; C-c u   uncomment-region
(global-set-key "u" (quote uncomment-region))
;; C-c g   goto-line
(global-set-key "g" (quote goto-line))

;; Useful key bindings
;; C-S-Back kill-whole-line
;; C-/ undo
;; C-o open-lien
;; C-M-o split-line


;; start server so we can edit it file under screen
;; (server-start)
;;(global-hi-lock-mode t)
;;(global-highlight-changes t)

;; indent whole buffer,
;; invoke by M-x iwb
(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil))

;; load ibuffer
;; refer to : http://learn.tsinghua.edu.cn:8080/2005211356/stdlib/Ibuffer.html
(require 'ibuffer nil t)
(require 'ibuf-ext nil t)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; load partial-complete
;; refer to : http://learn.tsinghua.edu.cn:8080/2005211356/stdlib/complete.html
;; (partial-completion-mode 1)

;; load ido-mode
;; refer to : http://learn.tsinghua.edu.cn:8080/2005211356/stdlib/ido.html
;; also refer to the comment part in : http://emacslife.blogspot.com/2008/02/icicles.html
(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point t)
(setq ido-auto-merge-work-directories-length -1)

(require 'recentf)
(setq recentf-max-saved-items 100)
;; from emacs wiki http://www.emacswiki.org/emacs/RecentFiles#toc7
(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(global-set-key [(meta f11)] 'recentf-ido-find-file)
(global-set-key `[27 f11] 'recentf-ido-find-file)

;; load dna-mode
;; ---Autoload:
;;  (autoload 'dna-mode "dna-mode" "Major mode for dna" t)
;;  (add-to-list 'magic-mode-alist '("^>\\|ID\\|LOCUS\\|DNA" . dna-mode))
;;  (add-to-list
;;     'auto-mode-alist
;;     '("\\.\\(fasta\\|fa\\|exp\\|ace\\|gb\\)\\'" . dna-mode))
;;  (add-hook 'dna-mode-hook 'turn-on-font-lock)
;;
;; ---Load:
;;  (setq dna-do-setup-on-load t)
;;  (load "~/emacs/dna-mode")

;; (global-set-key (kbd "<f5>") 'speedbar-get-focus)
(global-set-key (kbd "<f5>") 'sr-speedbar-toggle)
(global-set-key (quote [S-up]) (quote windmove-up))
(global-set-key (quote [S-down]) (quote windmove-down))
(global-set-key (quote [S-left]) (quote windmove-left))
(global-set-key (quote [S-right]) (quote windmove-right))

;; for convenient collapsing and expanding region
(require 'hideshow nil t)
(when (featurep 'hideshow)
  (dolist (hook '(c++-mode-hook c-mode-hook emacs-lisp-mode-hook
                                cperl-mode-hook))
    (add-hook hook 'hs-minor-mode)))
(global-set-key "t" (quote hs-toggle-hiding))

;; set TAGS directory
(setq tags-table-list '("." ".." "../.."))

;; set up ^C-o a prefix for outline mode
;; useful commands:
;; 1.  hide-sublevels (C-o C-q)
;;     show-all (C-o C-a)
;; 2.  hide-subtree (C-o C-d)
;;     hide-other (C-o C-o)
;;     show-subtree (C-o C-s)
;;
(setq outline-minor-mode-prefix [(control o)])

;; try hippie expand
;; refer to: http://lifegoo.pluskid.org/wiki/EmacsTip.html
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev                 ; .... buffer
        try-expand-dabbrev-visible         ; ........
        try-expand-dabbrev-all-buffers     ; .... buffer
        try-expand-dabbrev-from-kill       ; . kill-ring ...
        try-complete-file-name-partially   ; .......
        try-complete-file-name             ; .....
        try-expand-all-abbrevs             ; .......
        try-expand-list                    ; ......
        try-expand-line                    ; .....
        try-complete-lisp-symbol-partially ; .... elisp symbol
        try-complete-lisp-symbol))         ; .. lisp symbol


;; Completing numeric or algebraic expressions (using Calc (aka AdvancedDeskCalculator) and HippieExpand)
;; refer to: http://www.emacswiki.org/cgi-bin/wiki/MicheleBini
(defun my-try-complete-with-calc-result (arg)
  (and
   (not arg) (eolp)
   (save-excursion
     (beginning-of-line)
     (when (and (boundp 'comment-start)
                comment-start)
       (when (looking-at
              (concat
               "[ \n\t]*"
               (regexp-quote comment-start)))
         (goto-char (match-end 0))
         (when (looking-at "[^\n\t ]+")
           (goto-char (match-end 0)))))
     (looking-at ".* \\(\\([;=]\\) +$\\)"))
   (save-match-data
     (require 'calc-ext nil t))
   ;;(require 'calc-aent)
   (let ((start (match-beginning 0))
         (op (match-string-no-properties 2)))
     (save-excursion
       (goto-char (match-beginning 1))
       (if (re-search-backward (concat "[\n" op "]") start t)
           (goto-char (match-end 0)) (goto-char start))
       (looking-at (concat " *\\(.*[^ ]\\) +" op "\\( +\\)$"))
       (goto-char (match-end 2))
       (let* ((b (match-beginning 2))
              (e (match-end 2))
              (a (match-string-no-properties 1))
              (r (calc-do-calc-eval a nil nil)))
         (when (string-equal a r)
           (let ((b (save-excursion
                      (and (search-backward "\n\n" nil t)
                           (match-end 0))))
                 (p (current-buffer))
                 (pos start)
                 (s nil))
             (setq r
                   (calc-do-calc-eval
                    (with-temp-buffer
                      (insert a)
                      (goto-char (point-min))
                      (while (re-search-forward
                              "[^0-9():!^ \t-][^():!^ \t]*" nil t)
                        (setq s (match-string-no-properties 0))
                        (let ((r
                               (save-match-data
                                 (save-excursion
                                   (set-buffer p)
                                   (goto-char pos)
                                   (and
                                    ;; TODO: support for line
                                    ;; indentation
                                    (re-search-backward
                                     (concat "^" (regexp-quote s)
                                             " =")
                                     b t)
                                    (progn
                                      (end-of-line)
                                      (search-backward "=" nil t)
                                      (and (looking-at "=\\(.*\\)$")
                                           (match-string-no-properties 1))))))))
                          (if r (replace-match (concat "(" r ")") t t))))
                      (buffer-substring (point-min) (point-max)))
                    nil nil))))
         (and
          r
          (progn
            (he-init-string b e)
            (he-substitute-string (concat " " r))
            t)))))))
(setq hippie-expand-try-functions-list
      (cons
       'my-try-complete-with-calc-result
       (delq 'my-try-complete-with-calc-result
             hippie-expand-try-functions-list)))

;; deal with buffers with the same name
;; now will preced a directory name before actual file names.
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; auctex setting:
(add-to-list 'load-path "~/emacs/third/auctex/lisp")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(require 'tex-site)
(require 'tex)
(add-to-list 'TeX-command-list
             (list "dvipdfmx" "dvipdfmx %s.dvi" 'TeX-run-command nil t))

;;
;; from http://www.io.com/~jimm/emacs_tips.html#abbrev-mode
(define-key global-map [f9] 'bookmark-jump)
(define-key global-map [f10] 'bookmark-set)
(defalias 'bs 'bookmark-set)
(defalias 'bl 'bookmark-bmenu-list)
(setq bookmark-save-flag 1); How many mods between saves

;; manage bookmark
;; from http://emacsblog.org/2007/03/22/bookmark-mania/
(setq bm-restore-repository-on-load t)
(require 'bm)
(global-set-key `[27 f2] `bm-toggle)
(global-set-key `[f2] 'bm-next)
(global-set-key `[f12] 'bm-previous) ;; [f12] is Shift+F2

;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)

;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)

;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)

;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)

;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))


;; Use C-x a g to define a global abbreviation
;; and C-x a l to define an abbreviation that is
;; specific to the current major mode.
                                        ;(setq abbrev-file-name ("/GNU Emacs/abbrev_defs.el"))
                                        ;(read-abbrev-file abbrev-file-name t)
(setq dabbrev-case-replace nil)  ; Preserve case when expanding
(setq abbrev-mode t)


;; from:
;; http://sachachua.com/wp/2008/07/27/emacs-keyboard-shortcuts-for-navigating-code/
;; Type C-s (isearch-forward) to start interactively searching forward,
;; and type C-x to get the current word. Use C-s and C-r to search forward
;; and backward. You can modify your search, too.
(defun sacha/isearch-yank-current-word ()
  "Pull current word from buffer into search string."
  (interactive)
  (save-excursion
    (skip-syntax-backward "w_")
    (isearch-yank-internal
     (lambda ()
       (skip-syntax-forward "w_")
       (point)))))
(define-key isearch-mode-map (kbd "C-x") 'sacha/isearch-yank-current-word)


;; In every buffer, the line which contains the cursor will be fully
;; highlighted
(global-hl-line-mode 1)


(require 'ido)
(ido-mode t)

;; M-g g is the default goto-line
;; (global-set-key "\C-cl" 'goto-line)

(defun my-kill-whole-line ()
  "Kill an entire line, including trailing newline"
  (interactive)
  (beginning-of-line)
  (kill-line 1))


(defun tweakemacs-move-one-line-downward ()
  "Move current line downward once."
  (interactive)
  (forward-line)
  (transpose-lines 1)
  (forward-line -1))
(defun tweakemacs-move-one-line-upward ()
  "Move current line upward once."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(global-set-key (quote [C-M-up]) 'tweakemacs-move-one-line-upward)
(global-set-key (quote [C-M-down]) 'tweakemacs-move-one-line-downward)

;; easy binding for emacs
;; outline-mode-easy-bindings.el
;;
;; You can control outline entirely with Meta+<cursor> keys
;;
;; Store this file as outline-mode-easy-bindings.el somewhere in your
;; load-path and add the following lines to your init file:
;;
;;      (add-hook 'outline-mode-hook
;;                '(lambda ()
;;                   (require 'outline-mode-easy-bindings)))
;;
;;      (add-hook 'outline-minor-mode-hook
;;                '(lambda ()
;;                   (require 'outline-mode-easy-bindings)))

(defun outline-body-p ()
  (save-excursion
    (outline-back-to-heading)
    (outline-end-of-heading)
    (and (not (eobp))
         (progn (forward-char 1)
                (not (outline-on-heading-p))))))

(defun outline-body-visible-p ()
  (save-excursion
    (outline-back-to-heading)
    (outline-end-of-heading)
    (not (outline-invisible-p))))

(defun outline-subheadings-p ()
  (save-excursion
    (outline-back-to-heading)
    (let ((level (funcall outline-level)))
      (outline-next-heading)
      (and (not (eobp))
           (< level (funcall outline-level))))))

(defun outline-subheadings-visible-p ()
  (interactive)
  (save-excursion
    (outline-next-heading)
    (not (outline-invisible-p))))

(defun outline-do-close ()
  (interactive)
  (if (outline-on-heading-p)
      (cond ((and (outline-body-p)
                  (outline-body-visible-p))
             (hide-entry)
             (hide-leaves))
            (t
             (hide-subtree)))))

(defun outline-do-open ()
  (interactive)
  (if (outline-on-heading-p)
      (cond ((and (outline-subheadings-p)
                  (not (outline-subheadings-visible-p)))
             (show-children))
            ((and (not (outline-subheadings-p))
                  (not (outline-body-visible-p)))
             (show-subtree))
            ((and (outline-body-p)
                  (not (outline-body-visible-p)))
             (show-entry))
            (t
             (show-subtree)))))

(outline-minor-mode t)
(define-key outline-mode-map (kbd "M-<left>") 'outline-do-close)
(define-key outline-mode-map (kbd "M-<right>") 'outline-do-open)
(define-key outline-mode-map (kbd "M-<up>") 'outline-previous-visible-heading)
(define-key outline-mode-map (kbd "M-<down>") 'outline-next-visible-heading)


(define-key outline-minor-mode-map (kbd "M-<left>") 'outline-do-close)
(define-key outline-minor-mode-map (kbd "M-<right>") 'outline-do-open)
(define-key outline-minor-mode-map (kbd "M-<up>") 'outline-previous-visible-heading)
(define-key outline-minor-mode-map (kbd "M-<down>") 'outline-next-visible-heading)

(provide 'outline-mode-easy-bindings)

;; A smarter kill-region (C-w)
;; from: http://emacs.stackexchange.com/questions/2347/kill-or-copy-current-line-with-minimal-keystrokes
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

;; Make M-w do more intelligently. If region is active, behave like normal. Otherwise, do the following:
;; M-w copy url, email or current line, in that order
;; M-w followed by key f, l, s or w, copy filename, list, sexp and word, respectively
;; with numeric prefix, copy that many thing-at-point
;; from: http://www.emacswiki.org/emacs/Leo
;;; Copy thing-at-point intelligently
(defun sdl-kill-ring-save-thing-at-point (&optional n)
  "Save THING at point to kill-ring."
  (interactive "p")
  (let ((things '((?l . list) (?f . filename) (?w . word) (?s . sexp)))
        (message-log-max)               ; don't write to *Message*
        beg t-a-p thing event)
    (cl-flet ((get-thing ()
                         (save-excursion
                           (beginning-of-thing thing)
                           (setq beg (point))
                           (if (= n 1)
                               (end-of-thing thing)
                             (forward-thing thing n))
                           (buffer-substring beg (point)))))
      ;; try detecting url email and fall back to 'line'
      (dolist (thing '(url email line))
        (when (bounds-of-thing-at-point thing)
          (setq t-a-p (get-thing))
          ;; remove the last newline character
          (when (and (eq thing 'line)
                     (>= (length t-a-p) 1)
                     (equal (substring t-a-p -1) "\n"))
            (setq t-a-p (substring t-a-p 0 -1)))
          (kill-new t-a-p)
          (message "%s" t-a-p)
          (return nil)))
      (setq event (read-event nil))
      (when (setq thing (cdr (assoc event things)))
        (clear-this-command-keys t)
        (if (not (bounds-of-thing-at-point thing))
            (message "No %s at point" thing)
          (setq t-a-p (get-thing))
          (kill-new t-a-p 'replace)
          (message "%s" t-a-p))
        (setq last-input-event nil))
      (when last-input-event
        (clear-this-command-keys t)
        (setq unread-command-events (list last-input-event))))))

;; this function does not seems working...
;; (defun sdl-kill-ring-save-dwim ()
;;   "This command dwim on saving text.

;; If region is active, call `kill-ring-save'. Else, call
;; `sdl-kill-ring-save-thing-at-point'.

;; This command is to be used interactively."
;;   (interactive)
;;   (condition-case e
;;       (when (mark)
;;         (call-interactively 'kill-ring-save))
;;     ;; handler
;;     ('mark-inactive
;;      (call-interactively 'sdl-kill-ring-save-thing-at-point)))
;;   )
(defun sdl-kill-ring-save-dwim ()
  "This command dwim on saving text.

If region is active, call `kill-ring-save'. Else, call
`sdl-kill-ring-save-thing-at-point'.

This command is to be used interactively."
  (interactive)
  (if (use-region-p)
      (call-interactively 'kill-ring-save)
    (call-interactively 'sdl-kill-ring-save-thing-at-point)))

(global-set-key (kbd "M-w") 'sdl-kill-ring-save-dwim)

;; copy till end of line
(defun copy-to-end-of-line ()
  (interactive)
  (kill-ring-save (point)
                  (line-end-position))
  (message "Copied to end of line"))
(defun copy-line (arg)
  "Copy to end of line, or as many lines as prefix argument"
  (interactive "P")
  (if (null arg)
      (copy-to-end-of-line)
    (copy-whole-lines (prefix-numeric-value arg))))
(defun save-region-or-current-line (arg)
  (interactive "P")
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (copy-line arg)))
(global-set-key (kbd "M-W") 'save-region-or-current-line)

;; add redo mode
;; from: http://www.emacswiki.org/cgi-bin/wiki/RedoMode
(require 'redo)
(define-key global-map (kbd "C-x C-_") 'redo)

;; highlight parens
(defun hl-paren-highlight ()
  "Highlight the parentheses around point."
  (unless (= (point) hl-paren-last-point)
    (save-excursion
      (let ((pos (point))
            (match-pos (point))
            (level -1)
            (max (1- (length hl-paren-overlays))))
        (while (and match-pos (< level max))
          (setq match-pos
                (when (setq pos (cadr (syntax-ppss pos)))
                  (ignore-errors (scan-sexps pos 1))))
          (when match-pos
            (if (eq 'expression hl-paren-type)
                (hl-paren-put-overlay pos match-pos (incf level))
              (hl-paren-put-overlay pos (1+ pos) (incf level))
              (hl-paren-put-overlay (1- match-pos) match-pos
                                    (incf level)))
            ))
        (while (< level max)
          (hl-paren-put-overlay nil nil (incf level)))))
    (setq hl-paren-last-point (point))))

;; set up "tabbar"
;; from http://amitp.blogspot.com/2007/04/emacs-buffer-tabs.html
(require 'tabbar)
(set-face-attribute
 'tabbar-default nil
 :background "gray60")
(set-face-attribute
 'tabbar-unselected nil
 :background "gray85"
 :foreground "gray30"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background "#f2f2f6"
 :foreground "black"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box '(:line-width 1 :color "gray72" :style released-button))
(set-face-attribute
 'tabbar-separator nil
 :height 0.7)

(tabbar-mode 1)

;; customize shell-mode
;;; Shell mode
;; From Amit's blog
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'shell-mode-hook '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)

;; icicles
;; We temporarily not use it, since in text terminal,
;; icicles prompts are too messy
;; (add-to-list 'load-path "~/emacs/icicles")
;; (require 'icicles)


;; From http://infolab.stanford.edu/~manku/dotemacs.html
;; Removing Annoyances
;; will inhibit startup messages.
(setq inhibit-startup-message t)
;; will make the last line end in a carriage return.
(setq require-final-newline t)
;;  will allow you to type just "y" instead of "yes" when you exit.
(fset 'yes-or-no-p 'y-or-n-p)
;; will disallow creation of new lines when you press
;; the "arrow-down key" at end of the buffer.
(setq next-line-add-newlines nil)



;; General Embellishments
;; load auto-show (shows lines when cursor moves to right of long line).
;;(require 'auto-show) (auto-show-mode 1) (setq-default auto-show-mode t)
;; will position the cursor to end of output in shell mode.
;;(auto-show-make-point-visible)
;; will position cursor to end of output in shell mode automatically.
;;(auto-show-make-point-visible)
;; will highlight region between point and mark.
(transient-mark-mode t)
;;  denotes our interest in maximum possible fontification.
(setq font-lock-maximum-decoration t)

;; will highlight during query.
(setq query-replace-highlight t)
;; highlight incremental search
(setq search-highlight t)
;; will make text-mode default.
(setq default-major-mode 'text-mode)

;; get intermittent messages to stop typing
;; (type-break-mode)


(setq enable-recursive-minibuffers t) ;; allow recursive editing in minibuffer
;; (resize-minibuffer-mode 1)            ;; minibuffer gets resized if it becomes too big
(follow-mode t)                       ;; follow-mode allows easier editing of long files

(cond
 ((display-graphic-p)
  (set-foreground-color "blanched almond")
  (set-background-color "dark slate gray"))
 )

;;gud-mode (debugging with gdb)
(add-hook 'gud-mode-hook
          '(lambda ()
             (local-set-key [home]        ; move to beginning of line, after prompt
                            'comint-bol)
             (local-set-key [up]          ; cycle backward through command history
                            '(lambda () (interactive)
                               (if (comint-after-pmark-p)
                                   (comint-previous-input 1)
                                 (previous-line 1))))
             (local-set-key [down]        ; cycle forward through command history
                            '(lambda () (interactive)
                               (if (comint-after-pmark-p)
                                   (comint-next-input 1)
                                 (forward-line 1))))
             ))

;; shell-toggle.el stuff

(autoload 'shell-toggle "shell-toggle"
  "Toggles between the *shell* buffer and whatever buffer you are editing." t)
(autoload 'shell-toggle-cd "shell-toggle"
  "Pops up a shell-buffer and insert a \"cd \" command." t)
(global-set-key [f4] 'shell-toggle)
(global-set-key [C-f4] 'shell-toggle-cd)

;;; send region or current line to shell
(require 'sh-script)
;;; http://stackoverflow.com/questions/6286579/emacs-shell-mode-how-to-send-region-to-shell
(defun sh-send-line-or-region (&optional step)
  (interactive ())
  (let ((proc (get-process "shell"))
        pbuf min max command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (shell)
        (switch-to-buffer currbuff)
        (setq proc (get-process "shell"))
        ))
    (setq pbuff (process-buffer proc))
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))
    (setq command (concat (buffer-substring min max) "\n"))
    (with-current-buffer pbuff
      (goto-char (process-mark proc))
      (insert command)
      (move-marker (process-mark proc) (point))
      ) ;;pop-to-buffer does not work with save-current-buffer -- bug?
    (process-send-string  proc command)
    (display-buffer (process-buffer proc) t)
    (when step
      (goto-char max)
      (next-line))
    ))

(defun sh-send-line-or-region-and-step ()
  (interactive)
  (sh-send-line-or-region t))
(defun sh-switch-to-process-buffer ()
  (interactive)
  (pop-to-buffer (process-buffer (get-process "shell")) t))


(define-key sh-mode-map [(control ?j)] 'sh-send-line-or-region-and-step)
(define-key sh-mode-map [(control ?c) (control ?z)] 'sh-switch-to-process-buffer)

;; pager.el stuff
(require 'pager)
(global-set-key "\C-v"     'pager-page-down)
(global-set-key [next]     'pager-page-down)
(global-set-key "\ev"      'pager-page-up)
(global-set-key [prior]    'pager-page-up)
(global-set-key '[M-up]    'pager-row-up)
(global-set-key '[M-kp-8]  'pager-row-up)
(global-set-key '[M-down]  'pager-row-down)
(global-set-key '[M-kp-2]  'pager-row-down)

;; This is a way to hook tempo into cc-mode
(defvar c-tempo-tags nil
  "Tempo tags for C mode")
(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

;;; C-Mode Templates and C++-Mode Templates (uses C-Mode Templates also)
(require 'tempo)
(setq tempo-interactive t)

(add-hook 'c-mode-hook
          '(lambda ()
             (local-set-key [f11] 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             ))
(add-hook 'c++-mode-hook
          '(lambda ()
             (local-set-key [f11] 'tempo-complete-tag)
             (tempo-use-tag-list 'c-tempo-tags)
             (tempo-use-tag-list 'c++-tempo-tags)
             ))

;;; Preprocessor Templates (appended to c-tempo-tags)

(tempo-define-template "c-include"
                       '("include <" r ".h>" > n
                         )
                       "include"
                       "Insert a #include <> statement"
                       'c-tempo-tags)

(tempo-define-template "c-ifdef"
                       '("ifdef " (p "ifdef-clause: " clause) > n> p n
                         "#else /* !(" (s clause) ") */" n> p n
                         "#endif /* " (s clause)" */" n>
                         )
                       "ifdef"
                       "Insert a #ifdef #else #endif statement"
                       'c-tempo-tags)

(tempo-define-template "c-ifndef"
                       '("ifndef " (p "ifndef-clause: " clause) > n
                         "#define " (s clause) n> p n
                         "#endif /* " (s clause)" */" n>
                         )
                       "ifndef"
                       "Insert a #ifndef #define #endif statement"
                       'c-tempo-tags)
;;; C-Mode Templates

(tempo-define-template "c-if"
                       '(> "if (" (p "if-clause: " clause) ")" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
                       "if"
                       "Insert a C if statement"
                       'c-tempo-tags)

(tempo-define-template "c-else"
                       '(> "else" n>
                           "{" > n>
                           > r n
                           "}" > n>
                           )
                       "else"
                       "Insert a C else statement"
                       'c-tempo-tags)

(tempo-define-template "c-if-else"
                       '(> "if (" (p "if-clause: " clause) ")"  n>
                           "{" > n
                           > r n
                           "}" > n
                           "else" > n
                           "{" > n>
                           > r n
                           "}" > n>
                           )
                       "ifelse"
                       "Insert a C if else statement"
                       'c-tempo-tags)

(tempo-define-template "c-while"
                       '(> "while (" (p "while-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
                       "while"
                       "Insert a C while statement"
                       'c-tempo-tags)

(tempo-define-template "c-for"
                       '(> "for (" (p "for-clause: " clause) ")" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
                       "for"
                       "Insert a C for statement"
                       'c-tempo-tags)

(tempo-define-template "c-for-i"
                       '(> "for (" (p "variable: " var) " = 0; " (s var)
                           " < "(p "upper bound: " ub)"; " (s var) "++)" >  n>
                           "{" > n
                           > r n
                           "}" > n>
                           )
                       "fori"
                       "Insert a C for loop: for(x = 0; x < ..; x++)"
                       'c-tempo-tags)

(tempo-define-template "c-main"
                       '(> "int main(int argc, char *argv[])" >  n>
                           "{" > n>
                           > r n
                           > "return 0 ;" n>
                           > "}" > n>
                           )
                       "main"
                       "Insert a C main statement"
                       'c-tempo-tags)

(tempo-define-template "c-if-malloc"
                       '(> (p "variable: " var) " = ("
                           (p "type: " type) " *) malloc (sizeof(" (s type)
                           ") * " (p "nitems: " nitems) ") ;" n>
                           > "if (" (s var) " == NULL)" n>
                           > "error_exit (\"" (buffer-name) ": " r ": Failed to malloc() " (s var) " \") ;" n>
                           )
                       "ifmalloc"
                       "Insert a C if (malloc...) statement"
                       'c-tempo-tags)

(tempo-define-template "c-if-calloc"
                       '(> (p "variable: " var) " = ("
                           (p "type: " type) " *) calloc (sizeof(" (s type)
                           "), " (p "nitems: " nitems) ") ;" n>
                           > "if (" (s var) " == NULL)" n>
                           > "error_exit (\"" (buffer-name) ": " r ": Failed to calloc() " (s var) " \") ;" n>
                           )
                       "ifcalloc"
                       "Insert a C if (calloc...) statement"
                       'c-tempo-tags)

(tempo-define-template "c-switch"
                       '(> "switch (" (p "switch-condition: " clause) ")" n>
                           "{" >  n>
                           "case " (p "first value: ") ":" > n> p n
                           "break;" > n> p n
                           "default:" > n> p n
                           "break;" > n
                           "}" > n>
                           )
                       "switch"
                       "Insert a C switch statement"
                       'c-tempo-tags)

(tempo-define-template "c-case"
                       '(n "case " (p "value: ") ":" > n> p n
                           "break;" > n> p
                           )
                       "case"
                       "Insert a C case statement"
                       'c-tempo-tags)

(tempo-define-template "c++-class"
                       '("class " (p "classname: " class) p > n>
                         " {" > n
                         "public:" > n
                         "" > n
                         "protected:" > n
                         "" > n
                         "private:" > n
                         "" > n
                         "};" > n
                         )
                       "class"
                       "Insert a class skeleton"
                       'c++-tempo-tags)


;;Startup
(split-window-vertically)   ;; want two windows at startup
(other-window 1)              ;; move to other window
(shell)                       ;; start a shell
(rename-buffer "shell-first") ;; rename it
(other-window 1)              ;; move back to first window
;; (my-key-swap my-key-pairs)    ;; zap keyboard

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("ecbb4a94a854400f249b0966fa74ac47d63e1d6a15a85ac05a1ecc8612ddd9d9" default)))
 '(flycheck-googlelint-filter "-legal")
 '(max-specpdl-size 3200))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(font-lock-comment-face ((((class color) (min-colors 8) (background dark)) (:foreground "black")))))

(setq mac-command-key-is-meta t)

;; git
;; (add-to-list 'load-path "~/emacs/git")
(require 'git)
(require 'git-blame)

;; (add-to-list 'load-path "~/emacs/magit")
(require 'magit)

;; gtags
;; from http://www.newsmth.net/bbscon.php?bid=573&id=84691&ftype=3&num=1557
;; (add-to-list 'load-path "~/software/global/share/gtags")
(autoload 'gtags-mode "gtags" "" t)

(add-hook 'c-mode-hook
          '(lambda ()
             (gtags-mode 1)))

(add-hook 'c++-mode-hook
          '(lambda ()
             (gtags-mode 1)))

(add-hook 'asm-mode-hook
          '(lambda ()
             (gtags-mode 1)))

;;  from http://www.emacswiki.org/emacs/GnuGlobal
(defun gtags-root-dir ()
  "Returns GTAGS root directory or nil if doesn't exist."
  (with-temp-buffer
    (if (zerop (call-process "global" nil t nil "-pr"))
        (buffer-substring (point-min) (1- (point-max)))
      nil)))

;; from http://emacs-fu.blogspot.com/2009/01/navigating-through-source-code-using.html
(defun gtags-update ()
  "create or update the gnu global tag file"
  (interactive)
  (if (not (= 0 (call-process "global" nil nil nil " -p"))) ; tagfile doesn't exist?
      (let ((olddir default-directory)
            (topdir (read-directory-name
                     "gtags: top of source tree:" default-directory)))
        (cd topdir)
        (shell-command "gtags && echo 'created tagfile'")
        (cd olddir)) ; restore
    ;;  tagfile already exists; update it
    (shell-command "global -u && echo 'updated tagfile'")))

;; from: http://www.emacswiki.org/emacs/GnuGlobal
(defun gtags-update-single(filename)
  "Update Gtags database for changes in a single file"
  (interactive)
  (start-process "update-gtags" "update-gtags" "bash" "-c" (concat "cd " (gtags-root-dir) " ; gtags --single-update " filename )))

(defun gtags-update-current-file()
  (interactive)
  (defvar filename)
  (setq filename (replace-regexp-in-string (gtags-root-dir) "." (buffer-file-name (current-buffer))))
  (gtags-update-single filename)
  (message "Gtags updated for %s" filename))
(defun gtags-update-hook()
  "Update GTAGS file incrementally upon saving a file"
  (when gtags-mode
    (when (gtags-root-dir)
      (gtags-update-current-file))))
(add-hook 'after-save-hook 'gtags-update-hook)

;; from: http://www.emacswiki.org/emacs/CyclingGTagsResult
(defun ww-next-gtag ()
  "Find next matching tag, for GTAGS."
  (interactive)
  (let ((latest-gtags-buffer
         (car (delq nil  (mapcar (lambda (x) (and (string-match "GTAGS SELECT" (buffer-name x)) (buffer-name x)) )
                                 (buffer-list)) ))))
    (cond (latest-gtags-buffer
           (switch-to-buffer latest-gtags-buffer)
           (next-line)
           (gtags-select-it nil))
          ) ))

;; convenient setting
(gtags-mode 1)
(global-set-key "\M-;" 'ww-next-gtag)   ;; M-; cycles to next result, after doing M-. C-M-. or C-M-,
(global-set-key "\M-." 'gtags-find-tag) ;; M-. finds tag
(global-set-key (kbd "C-M-.") 'gtags-find-rtag)   ;; C-M-. find all references of tag
(global-set-key (kbd "C-M-,") 'gtags-find-symbol) ;; C-M-, find all usages of symbol.
(define-key gtags-mode-map "\e," 'gtags-find-tag-from-here)

;; M-x occur or M-x so => find occurance of word
;; M-x rgrep: recursively (including subdirectory) grep
;; M-x lgrep: local directory grep

;; from: http://sachachua.com/wp/2008/09/emacs-jump-to-anything/
(require 'anything)
(require 'anything-config)
(setq anything-sources
      (list anything-c-source-buffers
            anything-c-source-file-name-history
            anything-c-source-info-pages
            anything-c-source-man-pages
            anything-c-source-file-cache
            anything-c-source-emacs-commands))
(global-set-key (kbd "M-X") 'anything)

;; ;; interface to GNU idutils
;; ;; from http://www.gnu.org/software/idutils/manual/idutils.html#Emacs-gid-interface
;; (autoload 'gid "gid" nil t)

;; cflow is now a Emacs built-in mode
;; (autoload 'cflow-mode "cflow-mode")
;; (setq auto-mode-alist (append auto-mode-alist
;;                               '(("\\.cflow$" . cflow-mode))))

;; Try yet-another-snnipet
;; The latest version requires re-organize snippets, so not use it.
;; (add-to-list 'load-path
;;           "~/emacs/yasnippet")
;; (require 'yasnippet)
;; (yas-global-mode 1)
;; (setq yas/root-directory "~/emacs/mysnippets")

;; (add-to-list 'load-path "~/emacs/yasnippet-0.6.1c")
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/emacs/snippets"    ;; personal collectino
        ))
(yas-global-mode 1)

;; add smart-compile
;; (add-to-list 'load-path "~/emacs")
(require 'smart-compile)

;; ;; how to debug max-specpdl-size-errors?
;; ;; http://stackoverflow.com/questions/1322591/tracking-down-max-specpdl-size-errors-in-emacs
;; (setq max-specpdl-size 5)  ; default is 1000, reduce the backtrace level
;; (setq debug-on-error t)    ; now you should get a backtrace
;; ; now do something to repeat the bug

;; (setq load-path (cons "~/emacs/org-6.36c/lisp" load-path))
;; (require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; Org buffers only
;; add from tutorial http://orgmode.org/worg/org-tutorials/orgtutorial_dto.php
(setq org-log-done t)


;; lua-mode
;; from http://lua-mode.luaforge.net/
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; enable xterm mouse support
;; http://www.iterm2.com/#/section/faq
;; (require 'mouse)
;; (xterm-mouse-mode t)
;; (defun track-mouse (e))

(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])
(define-key input-decode-map "\e[1;5C" [C-right])
(define-key input-decode-map "\e[1;5D" [C-left])

;; (defvar gud-gdb-command-name "gdb75")
;; ;; (setq gud-gdb-command-name "gdb75 --annotate=3")
;; (setq gud-gdb-command-name "gdb75 --i=mi")

;; (require 'go-mode-load)
;; (setq load-path (cons "~/emacs/third/color-theme" load-path))
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

;; ;; (global-set-key (kbd "C-=") 'er/expand-region)  ;; this does not work in terminal mode
(global-set-key (kbd "M-=") 'er/expand-region)

;; https://github.com/winterTTr/ace-jump
;; (add-to-list 'load-path "~/emacs/ace-jump-mode")
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; how to
;; ,Y4C-c SPC,Y! ⇒ ace-jump-word-mode
;;   enter first char of a word, select the highlight key to move to.
;; ,Y4C-u C-c SPC,Y! ⇒ ace-jump-char-mode
;;   enter a char for query, select the highlight key to move to.
;; ,Y4C-u C-u C-c SPC,Y! ⇒ ace-jump-line-mode
;;  each non-empty line will be marked, select the highlight key to move to.


;; ;; https://gist.github.com/2350388
;; ;; Push mark when using ido-imenu
;; (defvar push-mark-before-goto-char nil)
;; (defadvice goto-char (before push-mark-first activate)
;;   (when push-mark-before-goto-char
;;     (push-mark)))
;; (defun ido-imenu-push-mark ()
;;   (interactive)
;;   (let ((push-mark-before-goto-char t))
;;     (ido-imenu)))


;; From: http://www.masteringemacs.org/articles/2012/10/02/iedit-interactive-multi-occurrence-editing-in-your-buffer/
(require 'iedit)
(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))
;; this may not work under terminal
;; (global-set-key (kbd "C-;") 'iedit-dwim)
(buffer-local-value 'major-mode (get-buffer "*scratch*"))


;; solving the problem when cannot use arrow keys to move around in screen
(define-key function-key-map "\eOA" [up])
(define-key function-key-map "\e[A" [up])
(define-key function-key-map "\eOB" [down])
(define-key function-key-map "\e[B" [down])
(define-key function-key-map "\eOC" [right])
(define-key function-key-map "\e[C" [right])
(define-key function-key-map "\eOD" [left])
(define-key function-key-map "\e[D" [left])

;; ;; https://github.com/capitaomorte/autopair
;; (add-to-list 'load-path "~/emacs/autopair")
;; (require 'autopair)
;; (autopair-global-mode)


;; require emacs > 23.3 to work
;; https://github.com/magnars/multiple-cursors.el
;; (add-to-list 'load-path "~/emacs/multiple-cursors.el")
(require 'multiple-cursors)
;; When you have an active region that spans multiple lines, the following will add a cursor to each line:
(global-set-key (kbd "C-C C-C") 'mc/edit-lines)
;;When you want to add multiple cursors not based on continuous lines, but based on keywords in the buffer, use:
(global-set-key (kbd "C-c >") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c <") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)

;; Lisp specific defuns
;; from: https://github.com/magnars/.emacs.d/blob/master/defuns/lisp-defuns.el
(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))


;; From:
;; http://www.emacswiki.org/emacs/BackToIndentationOrBeginning
(defun back-to-indentation-or-beginning ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))
(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)

;; From:
;; http://www.emacswiki.org/emacs/AutoIndentation
(defun kill-and-join-forward (&optional arg)
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))
(global-set-key "\C-k" 'kill-and-join-forward)

;; load htmize
(require 'htmlize)

;; (add-to-list 'load-path "~/emacs/markdown-mode/")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))

;; white-space mode to mark long lines
;; from: http://emacsredux.com/blog/2013/05/31/highlight-lines-that-exceed-a-certain-length-limit/
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)

;; Open line above
;; http://emacsredux.com/blog/2013/06/15/open-line-above/
(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))
;; (global-set-key [(control shift return)] 'smart-open-line-above)
;;(global-set-key (kbd "M-o") 'smart-open-line)
;;(global-set-key (kbd "M-O") 'smart-open-line-above)
;; my customization
(global-set-key (kbd "M-o") 'smart-open-line-above)

;; Smart C-a
;; http://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
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

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

;; Leave just one space
;; http://emacsredux.com/blog/2013/05/19/delete-whitespace-around-point/
(global-set-key (kbd "C-c j") 'just-one-space)


(require 'move-text)
(move-text-default-bindings)

;; ;; Key-chord mode
;; ;; define two key sequence as shortcuts
;; (require 'key-chord)

;; (key-chord-define-global "BB" 'iswitchb)
;; (key-chord-define-global "FF" 'find-file)
;; (key-chord-define-global "jk" 'beginning-of-buffer)
;; (defun switch-to-previous-buffer ()
;;   "Switch to previously open buffer.
;; Repeated invocations toggle between the two most recently open buffers."
;;   (interactive)
;;   (switch-to-buffer (other-buffer (current-buffer) 1)))
;; (key-chord-define-global "JJ" 'switch-to-previous-buffer)
;; (key-chord-define-global "WO" 'other-window)

;; ;; set up chord binding for moving up and down
;; (key-chord-define-global "UU" 'move-text-up)
;; (key-chord-define-global "DD" 'move-text-down)

;; (key-chord-mode +1)

;; just to previous window
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1)))


;; unod-tree
(require 'undo-tree)
;; (key-chord-define-global "uu" 'undo-tree-visualize)

;; very quickly jump to a simple within the buffer
;; http://wikemacs.org/index.php/Imenu
(defun ido-goto-symbol (&optional symbol-list)
  "Refresh imenu and jump to a place in the buffer using Ido."
  (interactive)
  (unless (featurep 'imenu)
    (require 'imenu nil t))
  (cond
   ((not symbol-list)
    (let ((ido-mode ido-mode)
          (ido-enable-flex-matching
           (if (boundp 'ido-enable-flex-matching)
               ido-enable-flex-matching t))
          name-and-pos symbol-names position)
      (unless ido-mode
        (ido-mode 1)
        (setq ido-enable-flex-matching t))
      (while (progn
               (imenu--cleanup)
               (setq imenu--index-alist nil)
               (ido-goto-symbol (imenu--make-index-alist))
               (setq selected-symbol
                     (ido-completing-read "Symbol? " symbol-names))
               (string= (car imenu--rescan-item) selected-symbol)))
      (unless (and (boundp 'mark-active) mark-active)
        (push-mark nil t nil))
      (setq position (cdr (assoc selected-symbol name-and-pos)))
      (cond
       ((overlayp position)
        (goto-char (overlay-start position)))
       (t
        (goto-char position)))))
   ((listp symbol-list)
    (dolist (symbol symbol-list)
      (let (name position)
        (cond
         ((and (listp symbol) (imenu--subalist-p symbol))
          (ido-goto-symbol symbol))
         ((listp symbol)
          (setq name (car symbol))
          (setq position (cdr symbol)))
         ((stringp symbol)
          (setq name symbol)
          (setq position
                (get-text-property 1 'org-imenu-marker symbol))))
        (unless (or (null position) (null name)
                    (string= (car imenu--rescan-item) name))
          (add-to-list 'symbol-names name)
          (add-to-list 'name-and-pos (cons name position))))))))

(global-set-key (kbd "C-c i") 'ido-goto-symbol) ; or any key you see fit


;; enable window-number for fast jumping between windows
;; use M-1, M-2 to jump between windows
(require 'window-number)
(window-number-meta-mode 1)

;; Below are customized by
;; http://www.jesshamrick.com/2012/09/18/emacs-as-a-python-ide/?utm_source=Python+Weekly+Newsletter&utm_campaign=611942dc15-Python_Weekly_Issue_107_October_3_2013&utm_medium=email&utm_term=0_9e26887fc5-611942dc15-312662625
;; auto-complete
;; (add-to-list 'load-path "~/emacs/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/emacs/auto-complete/ac-dict")
(ac-config-default)


;; fill-column-indicator
;; fci-rule-column
;; (add-to-list 'load-path "~/emacs/fill-column-indicator-1.83")
(require 'fill-column-indicator)
(setq-default fci-rule-column 80)
(define-globalized-minor-mode
  global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)
;; (global-fci-mode 0)

;; use paredit
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
;; paredit can be used to slurp right parens

;; smartparens
;; https://github.com/Fuco1/smartparens/wiki/Example-configuration
;; ------ begin ------
;;;;;;;;;
;; global
(require 'smartparens-config)
(smartparens-global-mode t)

;; highlights matching pairs
(show-smartparens-global-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;
;; keybinding management

(define-key sp-keymap (kbd "C-M-f") 'sp-forward-sexp)
(define-key sp-keymap (kbd "C-M-b") 'sp-backward-sexp)

(define-key sp-keymap (kbd "C-M-d") 'sp-down-sexp)
(define-key sp-keymap (kbd "C-M-a") 'sp-backward-down-sexp)
(define-key sp-keymap (kbd "C-S-a") 'sp-beginning-of-sexp)
(define-key sp-keymap (kbd "C-S-d") 'sp-end-of-sexp)

(define-key sp-keymap (kbd "C-M-e") 'sp-up-sexp)
(define-key emacs-lisp-mode-map (kbd ")") 'sp-up-sexp)
(define-key sp-keymap (kbd "C-M-u") 'sp-backward-up-sexp)
(define-key sp-keymap (kbd "C-M-t") 'sp-transpose-sexp)

(define-key sp-keymap (kbd "C-M-n") 'sp-next-sexp)
(define-key sp-keymap (kbd "C-M-p") 'sp-previous-sexp)

(define-key sp-keymap (kbd "C-M-k") 'sp-kill-sexp)
(define-key sp-keymap (kbd "C-M-w") 'sp-copy-sexp)

(define-key sp-keymap (kbd "M-<delete>") 'sp-unwrap-sexp)
(define-key sp-keymap (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)

(define-key sp-keymap (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key sp-keymap (kbd "C-<left>") 'sp-forward-barf-sexp)
(define-key sp-keymap (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
(define-key sp-keymap (kbd "C-M-<right>") 'sp-backward-barf-sexp)

(define-key sp-keymap (kbd "M-D") 'sp-splice-sexp)
(define-key sp-keymap (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
(define-key sp-keymap (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
(define-key sp-keymap (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)

(define-key sp-keymap (kbd "C-]") 'sp-select-next-thing-exchange)
(define-key sp-keymap (kbd "C-<left_bracket>") 'sp-select-previous-thing)
(define-key sp-keymap (kbd "C-M-]") 'sp-select-next-thing)

(define-key sp-keymap (kbd "M-F") 'sp-forward-symbol)
(define-key sp-keymap (kbd "M-B") 'sp-backward-symbol)

(define-key sp-keymap (kbd "H-t") 'sp-prefix-tag-object)
(define-key sp-keymap (kbd "H-p") 'sp-prefix-pair-object)
(define-key sp-keymap (kbd "H-s c") 'sp-convolute-sexp)
(define-key sp-keymap (kbd "H-s a") 'sp-absorb-sexp)
(define-key sp-keymap (kbd "H-s e") 'sp-emit-sexp)
(define-key sp-keymap (kbd "H-s p") 'sp-add-to-previous-sexp)
(define-key sp-keymap (kbd "H-s n") 'sp-add-to-next-sexp)
(define-key sp-keymap (kbd "H-s j") 'sp-join-sexp)
(define-key sp-keymap (kbd "H-s s") 'sp-split-sexp)

;;;;;;;;;;;;;;;;;;
;; pair management

(sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

;;; markdown-mode
(sp-with-modes '(markdown-mode gfm-mode rst-mode)
                 (sp-local-pair "*" "*" :bind "C-*")
                   (sp-local-tag "2" "**" "**")
                     (sp-local-tag "s" "```scheme" "```")
                       (sp-local-tag "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags))

;;; tex-mode latex-mode
(sp-with-modes '(tex-mode plain-tex-mode latex-mode)
                 (sp-local-tag "i" "\"<" "\">"))

;;; html-mode
(sp-with-modes '(html-mode sgml-mode)
                 (sp-local-pair "<" ">"))

;;; lisp modes
(sp-with-modes sp--lisp-modes
                 (sp-local-pair "(" nil :bind "C-("))

;; convenient function
(global-set-key (kbd "C-M-k") 'kill-whole-line)

;; show TABs by default
(require 'highlight-chars)
(add-hook 'font-lock-mode-hook 'hc-highlight-tabs)
;; ------ end ------



;; use ipython
;; http://www.emacswiki.org/emacs?action=browse;oldid=PythonMode;id=PythonProgrammingInEmacs
;; useful keys:
;; C-c C-c         python-shell-send-buffer
;; C-c C-r         python-shell-send-region
;; C-c C-z         python-shell-switch-to-shell
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
 "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
 "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
 "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")
(setq py-shell-name "ipython")

;; let imenu support python
;; http://stackoverflow.com/questions/6317667/fabian-gallinas-python-el-imenu-support
(add-hook 'python-mode-hook
          (lambda ()
                (setq imenu-create-index-function 'python-imenu-create-index)))
;; ;; Pymacs + Ropemacs

;; Ropemacs
;; (require 'pymacs)
;; (pymacs-load "ropemacs" "rope-") ; note this line will make 'M-x help' function disabled
;; so we use hook function as below
(defun load-ropemacs ()
  "Load pymacs and ropemacs"
  (interactive)
                                        ;(setenv "PYMACS_PYTHON" "python2.5") ; disabled for now
                                        ; (require 'python-mode)
  (require 'pymacs)
  (autoload 'pymacs-apply "pymacs")
  (autoload 'pymacs-call "pymacs")
  (autoload 'pymacs-eval "pymacs" nil t)
  (autoload 'pymacs-exec "pymacs" nil t)
  (autoload 'pymacs-load "pymacs" nil t)
  ;; (eval-after-load "pymacs"
  ;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))
  (pymacs-load "ropemacs" "rope-")
  ;; (setq rope-confirm-saving 'nil)
  ;; (ropemacs-mode t)
  ;; (local-set-key [(meta ?/)] 'rope-code-assist) ;; avoid rope start for C++ file
  )
(add-hook 'python-mode-hook 'load-ropemacs)

;; automatically convert tab to spaces for python
(defun my-python-mode-common-hook ()
  (setq-default indent-tabs-mode nil)
  )
(add-hook 'python-mode-hook 'my-python-mode-common-hook)

(setq python-shell-interpreter "ipython")
;; enable jedi for python
(require 'epc)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional
;; need to make sure jedi is installed
;; refer to http://tkf.github.io/emacs-jedi/latest/#pyinstall
;; (setq jedi:server-command '("~/.emacs.d/elpa/jedi-core-20150305.212/jediepcserver.py"))


;; ;; use emacs-jedi
;; (add-to-list 'load-path "~/emacs/emacs-deferred")
;; (add-to-list 'load-path "~/emacs/emacs-ctable")
;; (add-to-list 'load-path "~/emacs/emacs-epc")

;; (add-to-list 'load-path "~/emacs/emacs-jedi")
;; (autoload 'jedi:setup "jedi" nil t)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:setup-keys t)                      ; optional
;; (setq jedi:complete-on-dot t)                 ; optional

;; ;; set-up ipython according to http://ipython.org/ipython-doc/1/config/editors.html
;; (setq py-python-command-args '("--matplotlib" "--colors" "LightBG"))
;; (setq ipython-command "/usr/bin/ipython")
;; (require 'ipython)

;; (add-to-list 'load-path "~/emacs/isend-mode.el")
;; (require 'isend)

;; from:
;; http://www.plope.com/Members/chrism/flymake-mode
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pyflakes" (list local-file))))

;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))

;; (add-hook 'find-file-hook 'flymake-find-file-hook)

;; enable flymake-cursor
;; (require 'flymake-cursor)

;; Config flychecker-google-cpplint
;; Prompt if cpplint.py is not found
(unless (executable-find "cpplint.py")
  (warn "Cannot find executable cpplint.py"))
(eval-after-load 'flycheck
  '(progn
     (require 'flycheck-google-cpplint)
     ;; Add Google C++ Style checker.
     ;; In default, syntax checked by Clang and Cppcheck.
     (custom-set-variables
      '(flycheck-googlelint-filter "-legal"))
     (flycheck-add-next-checker 'c/c++-gcc
                                'c/c++-googlelint 'append)))

;; (setq debug-on-error t)

;; (defun send-buffer-to-ipython ()
;;   "Send current buffer to the running ipython process."
;;   (interactive)
;;   (let* ((ipython-buffer "*ansi-term*") ; the buffer name of your running terminal
;;          (proc (get-buffer-process ipython-buffer)))
;;     (unless proc
;;       (error "no process found"))
;;     (save-buffer)
;;     (process-send-string proc
;;                          (format "execfile(\"%s\")\n" (buffer-file-name)))
;;     (pop-to-buffer ipython-buffer)      ; show ipython and select it
;;     ;; (display-buffer ipython-buffer)  ; show ipython but don't select it
;;     ))

(global-set-key (kbd "M-m") 'iy-go-to-char)

;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.  Otherwise, typed text is just inserted at
;; point regardless of any selection.
(pending-delete-mode t)

;; from gist:
;; https://gist.github.com/magnars/2360578
(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols (delq nil (mapcar (lambda (symbol)
                                                     (if (string-match regexp symbol) symbol))
                                                   symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc (lambda (symbol) (setq symbol-names (cons symbol (delete symbol symbol-names))))
                  matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))

;; From gist: https://gist.github.com/magnars/2350388
;; Refer to Emacs rocks #10
;; Push mark when using ido-imenu
(defvar push-mark-before-goto-char nil)
(defadvice goto-char (before push-mark-first activate)
  (when push-mark-before-goto-char
    (push-mark)))
(defun ido-imenu-push-mark ()
  (interactive)
  (let ((push-mark-before-goto-char t))
    (ido-imenu)))
(global-set-key (kbd "C-x C-i") 'ido-imenu-push-mark)

;; customize smex
;; https://github.com/nonsequitur/smex
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                                        ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)

;; (require 'powerline)
;; (powerline-default-theme)
;; (powerline-center-theme)

;; proxy settings, so that Emacs can access melpa, elpa repos
(if (or (string-suffix-p ".swmed.edu" system-name)
        (string= "zhanxw-VirtualBox" system-name)
        (string= "purcell" system-name))
    (setq url-proxy-services
          '(("no_proxy" . "^localhost")
            ("http" . "proxy.swmed.edu:3128")
            ("https" . "proxy.swmed.edu:3128")
            ("ftp" . "proxy.swmed.edu:3128"))))

;; anzu mode
;; a minor mode which displays current match and total matches information in
;; the mode-line in various search modes.
(global-anzu-mode +1)


;; rainbox-delimiter
;; https://github.com/Fanael/rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; ;; enable workgroups2
;; ;; this should be put at the end of .emacs
;; By default prefix is: "C-c z"
;; <prefix> <key>

;; <prefix> c    - create workgroup
;; <prefix> A    - rename workgroup
;; <prefix> k    - kill workgroup
;; <prefix> v    - switch to workgroup
;; <prefix> C-s  - save session
;; <prefix> C-f  - load session
;; ----------------------
;; Type "<prefix> ?" for more help
(require 'workgroups2)
(workgroups-mode 1)  ; put this one at the bottom of .emacs
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
