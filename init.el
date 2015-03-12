;;; init.el --- Where all the magic begins
;;
;; load Org-mode from source when the ORG_HOME environment variable is set

(when (getenv "ORG_HOME")
  (let ((org-lisp-dir (expand-file-name "lisp" (getenv "ORG_HOME"))))
    (when (file-directory-p org-lisp-dir)
      (add-to-list 'load-path org-lisp-dir)
      (require 'org))))

;; load the starter kit from the `after-init-hook' so all packages are loaded
(add-hook 'after-init-hook
 `(lambda ()
    ;; remember this directory
    (setq starter-kit-dir
          ,(file-name-directory (or load-file-name (buffer-file-name))))
    ;; only load org-mode later if we didn't load it just now
    ,(unless (and (getenv "ORG_HOME")
                  (file-directory-p (expand-file-name "lisp"
                                                      (getenv "ORG_HOME"))))
       '(require 'org))
    ;; load up the starter kit
    (org-babel-load-file (expand-file-name "starter-kit.org" starter-kit-dir))))

;;; init.el ends here



(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))
(load-file "~/.emacs.d/themes/jazz-theme.el")

(setq make-backup-files nil)
(setq confirm-kill-emacs 'yes-or-no-p)

(setq-default indent-tabs-mode nil)            ; Use spaces instead of tabs
(setq tab-width 4)                             ; Length of tab is 4 SPC
(setq sentence-end-double-space nil)           ; Sentences end with one space
(setq truncate-partial-width-windows nil)      ; Don't truncate long lines
(setq-default indicate-empty-lines t)          ; Show empty lines
(setq next-line-add-newlines t)                ; Add newline when at buffer end
(setq require-final-newline 't)                ; Always newline at end of file
(global-linum-mode 1)                          ; Show line numbers on buffers
(show-paren-mode 1)                            ; Highlight parenthesis pairs
(setq blink-matching-paren-distance nil)       ; Blinking parenthesis
(setq show-paren-style 'expression)

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)


(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(add-to-list 'load-path "~/.emacs.d/plugins/go-autocomplete")
(add-to-list 'load-path "~/.emacs.d/plugins/popup-el")
(add-to-list 'load-path "~/.emacs.d/plugins/editorconfig")
(add-to-list 'load-path "~/.emacs.d/plugins/thrift")
(add-to-list 'load-path "~/.emacs.d/plugins/go-mode")
(add-to-list 'load-path "~/.emacs.d/elpa/handlebars-mode-20150211.949/plugins/handlebars-mode")



(require 'yasnippet)
(yas-global-mode 1)
;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(show-paren-mode t)

(setq backup-directory-alist '(("." . "~/.autosave")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(if window-system (tool-bar-mode -1))

(defalias 'yes-or-no-p 'y-or-n-p)

(set-default 'kill-whole-line t)

(set-default 'tab-width 2)

(set-default 'indent-tabs-mode nil)

(defun cleanup-on-write-file ()
  (save-excursion
    (delete-trailing-whitespace)
    (if (not indent-tabs-mode)
        (untabify (point-min) (point-max)))))
;; ;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks
          (lambda () (cleanup-on-write-file) nil))

(column-number-mode t)

(delete-selection-mode t)

(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(push "/usr/local/bin" exec-path)

(set-default 'fill-column 79)

(add-hook 'python-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "pylint --indent-string='  ' --msg-template='{path}:{line}: {msg_id}({symbol}): {msg}' -rn " buffer-file-name))))

(add-to-list 'load-path "~/.emacs.d/")
(load "editorconfig")
(load "thrift")
(load "go-mode")
(add-hook 'before-save-hook #'gofmt-before-save)
(load "auto-complete")
(require 'auto-complete-config)

(global-auto-revert-mode t)

(defun unixify ()
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix))

(set-default 'js-indent-level 2)
(set-default 'css-indent-offset 2)

(setenv "GOPATH" (concat (getenv "HOME") "/gopath"))
(setenv "PATH" (concat (getenv "GOPATH") "/bin" ":" (getenv "PATH")))
(setq exec-path (append exec-path (list (concat (getenv "GOPATH") "/bin"))))
(put 'upcase-region 'disabled nil)
(global-set-key (kbd "C-x C-f") 'fiplr-find-file)
