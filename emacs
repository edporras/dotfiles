;; use MELPA packages
(cond
     ((string-match "Emacs 24" (emacs-version))
      (message "customizing GNU Emacs")
      ;; more (and more up-to-date) packages than plain ELPA
      (require 'package)
      (add-to-list 'package-archives
		   '("melpa" . "http://melpa.milkbox.net/packages/")
		   '("marmalade" . "http://marmalade-repo.org/packages/"))
      (package-initialize)
))

(if (fboundp 'ns-find-file)
    (global-set-key [ns-drag-file] 'ns-find-file))
(setq ns-pop-up-frames nil)
(when (eq system-type 'darwin)
    ;; These configuration seems to work in
    ;; GNU Emacs 24.1.1 (x86_64-apple-darwin, NS apple-appkit-1038.36)
    ;; of 2012-06-11 on bob.porkrind.org

    ;; default font family
;;    (set-face-attribute 'default nil :family "Deja Vu Sans Mono")

    ;; default font size
    ;;
    ;; WARNING: depending on the default font, some height value may
    ;; cause a broken frame display; that is, the beginning of the
    ;; buffer is not visible.
    (set-face-attribute 'default nil :height 100)

    ;; You may add :size POINT in below font-spec if you want to use
    ;; specific size of Hangul font regardless of default font size
;;    (set-fontset-font t 'hangul
;;                      (font-spec :name "NanumGothicCoding"))

    ;; window size
    (setq default-frame-alist '((width . 105) (height . 60) (menu-bar-lines . 2)))
    (add-to-list 'default-frame-alist '(cursor-color . "palegoldenrod"))
;;    (set-frame-parameter nil 'fullscreen 'fullboth)
;;    (require 'frame-cmds)

    ;; bg-color
    (add-to-list 'default-frame-alist '(background-color . "darkslategray"))
    (add-to-list 'default-frame-alist '(foreground-color . "white"))

    ;; drop window chrome
    (setq menu-bar-mode -1
          tool-bar-mode -1
          fringe-mode -1
          scroll-bar-mode -1)

    ;; speed up screen re-paint
    (setq redisplay-dont-pause t)

    ;; typeface and spacing
;;    (set-default-font "-apple-DejaVu_Sans_Mono-medium-normal-normal-*-10-*-*-*-m-0-iso10646-1")
;;    (setq-default line-spacing 3)

    ;; OS X Lion fullscreen mode command-returns
    (setq mac-right-alternate-modifier nil)
;;    (global-set-key (kbd "<s-return>") 'ns-toggle-fullscreen)

    ;; use OS X's Spotlight for M-x locate
    (setq locate-make-command-line (lambda (s) `("mdfind" "-name" ,s)))

    ;; default path to find files
    (setq default-directory (concat (getenv "HOME") "/work/"))
    )

;; shortcut
(defalias 'yes-or-no-p 'y-or-n-p)
;; turn off splash screen messages
(setq inhibit-startup-echo-area-message t
      inhibit-startup-screen t)
;; Show me empty lines after buffer end
(set-default 'indicate-empty-lines t)

(add-to-list 'load-path (expand-file-name "~/Library/Application Support/emacs/site-lisp/pdf-mode"))
;;(add-to-list 'load-path (expand-file-name "~ep/Library/Application Support/emacs/site-lisp/ruby-mode"))
;;(add-to-list 'load-path (expand-file-name "~ep/Library/Application Support/emacs/site-lisp/"))
(setq auto-mode-alist (append
		       '(
                         ("\\.html$"  . sgml-mode)
;;                         ("\\.html$"  . html-wrap-mode)
			 ("\\.c\\'"   . c++-mode)
			 ("\\.cc\\'"  . c++-mode)
			 ("\\.h\\'"   . c++-mode)
			 ("\\.ipp\\'" . c++-mode)
			 ("\\.php\\'" . php-mode)
			 ("\\.pdf\\'" . pdf-mode)
			 ("\\.xml\\'" . xml-mode)
			 ("\\.rb\\'"  . ruby-mode)
			 ("\\.erb\\'" . ruby-mode)
			 ("\\.gemspec\\'" . ruby-mode)
			 ("\\Rakefile\\'" . ruby-mode)
			 ("\\.java$'" . java-mode)
			 ("\\.css$"   . css-mode)
			 ("\\.inc\\'" . makefile-mode)
                         ("\\.mak\\'" . makefile-mode)
			 )
		       auto-mode-alist))
;; ruby-mode config
(autoload 'ruby-mode "ruby-mode" "Major mode for editing Ruby code" t)
(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(require 'ruby-electric)
(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))
(defadvice ruby-indent-line (after line-up-args activate)
  (let (indent prev-indent arg-indent)
    (save-excursion
      (back-to-indentation)
      (when (zerop (car (syntax-ppss)))
        (setq indent (current-column))
        (skip-chars-backward " \t\n")
        (when (eq ?, (char-before))
          (ruby-backward-sexp)
          (back-to-indentation)
          (setq prev-indent (current-column))
          (skip-syntax-forward "w_.")
          (skip-chars-forward " ")
          (setq arg-indent (current-column)))))
    (when prev-indent
      (let ((offset (- (current-column) indent)))
        (cond ((< indent prev-indent)
               (indent-line-to prev-indent))
              ((= indent prev-indent)
               (indent-line-to arg-indent)))
        (when (> offset 0) (forward-char offset))))))
;; css-mode plus fixes from http://www.robsearles.com/2009/10/29/emacs-css-mode-fix/
(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
;;(require 'css-mode)
(setq cssm-indent-level 2)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-mirror-mode t)
;; markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
;; my development mode
(defun my-dev-mode-hook ()
  ;; don't use tabs, really.. make them spaces
  (setq-default indent-tabs-mode nil)
  ;; enable Emacs Code Browser
;;  (setq-default ecb-auto-activate t)
  ;; ctrl-c ctrl-c to compile
  (define-key c++-mode-map "\C-c\C-c" 'compile)
  )
;; apply this hook to C, C++ and Java modes
(add-hook 'c-mode-hook 'my-dev-mode-hook)
(add-hook 'c++-mode-hook 'my-dev-mode-hook)
;; ctrl-x l -> goto line
(define-key ctl-x-map "l" 'goto-line)
;; force comment colors
(set-face-foreground 'font-lock-comment-face "#aaa")
;; speedbar
(require 'sr-speedbar)
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)
;; tramp
(require 'tramp)
;; to control how to split windows
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
(define-key ctl-x-4-map "t" 'toggle-window-split)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-offsets-alist (quote ((substatement-open . 0) (case-label . 2))))
 '(column-number-mode t)
 '(compilation-scroll-output t)
 '(compile-command "make -k -j 5")
 '(exec-path
   (quote
    ("/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin-x86_64-10_9" "/Applications/Emacs.app/Contents/MacOS/libexec-x86_64-10_9" "/Applications/Emacs.app/Contents/MacOS/libexec" "/Applications/Emacs.app/Contents/MacOS/bin")))
 '(ggtags-executable-directory "/usr/local/bin")
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(make-backup-files nil)
 '(markdown-command "/usr/local/bin/markdown")
 '(menu-bar-mode -1)
 '(require-final-newline f)
 '(safe-local-variable-values (quote ((c-file-style . ruby) (encoding . utf-8))))
 '(save-place t nil (saveplace))
 '(scroll-step 1)
 '(show-trailing-whitespace t)
 '(size-indication-mode t)
 '(sr-speedbar-skip-other-window-p t)
 '(tool-bar-mode nil)
 '(which-function-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
