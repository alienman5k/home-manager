;; -*- eval: (outline-minor-mode); -*-

;;; Benchmark initialization
(setq gc-cons-threshold (* 50 1000 1000)) ;; This helps reducing garbage collection during emacs-startup
(add-hook 'emacs-startup-hook (lambda ()
				(setq gc-cons-threshold 800000)
				(message "Emacs started in %s seconds with %d garbage collections"
					 (emacs-init-time "%.2f") gcs-done)))

;;; Personal Information
(setq user-full-name "Ignacio Marmolejo"
      user-mail-address "ignacio.marmolejo@oracle.com"
      user-login-name "imarmole")

;;; UI Changes
;;;; Fonts
(set-face-attribute 'default nil
		    :font "BlexMono Nerd Font Mono"
		    :weight 'normal
		    :width 'normal
		    :height 130)
(set-face-attribute 'variable-pitch nil
		    :font "Fira Sans"
		    :height 130)

;;;; Clean UI
(setq inhibit-startup-message t    ;; No startup buffer
      make-backup-files nil        ;; Do not create backup files
      confirm-kill-emacs 'y-or-n-p ;; Show message before killing
      use-short-ansers t           ;; Use y/n instead of yes/no answers
			display-line-numbers-type 'visual)
(scroll-bar-mode -1) ;; No scroll bar
(tool-bar-mode -1) ;; No tool bar
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(global-display-line-numbers-mode)
(desktop-save-mode 0) ;; Restore last window confifuration, ie. tabs.

(setq custom-file "~/.config/emacs-custom.el")
;; (load custom-file)

(use-package exec-path-from-shell
	:if (eq system-type 'darwin)
	:init
	(exec-path-from-shell-initialize))

(use-package ns-auto-titlebar
	:if (eq system-type 'darwin)
	:config
	(ns-auto-titlebar-mode))

(use-package ef-themes
  :config
  (ef-themes-select 'ef-light t))
 
(use-package which-key
  :config
  (which-key-mode 1))

;;; Customize org-mode
(use-package org
  :mode (("\\.org$" . org-mode))
  ;;:ensure org-plus-contrib
  :custom
  (org-edit-src-content-indentation 0)
  (org-ellipsis " ↘")
  (org-export-backends '(ascii html odt md))
  (org-confirm-babel-evaluate
	(lambda (lang body)
	  (and (not (string= lang "emacs-lisp"))
	       (not (string= lang "elisp"))
	       (not (string= lang "restclient"))
	       (not (string= lang "python"))))))

;;; External Packages
;;;; Evil Mode
(use-package evil
  :demand t
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-undo-system 'undo-redo)
  (evil-want-C-u-scroll t)
  (evil-want-C-i-jump nil)
  :config
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;;;; Orderless
(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;;; Corfu
(use-package corfu
  :custom
  (corfu-separator ?\s) ;; Orderless field separator               
  (corfu-cycle t)	;; Enable cycling for `corfu-next/previous'  
  :init
  (global-corfu-mode))

;;;; Vertico
(use-package vertico
  :init (vertico-mode 1)
  :config
  (setq vertico-cycle t)
  ;;; History mode
  (savehist-mode t)
  (save-place-mode 1)
  (recentf-mode 1))
(use-package vertico-directory
  ;; :straight nil
  ;; :load-path "straight/build/vertico/extensions/"
  :after vertico
  ;; this adds -hook explicitly so we need to remove the -hook portion
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind (:map vertico-map
	      ("\r" . vertico-directory-enter)
	      ("\d" . vertico-directory-delete-char)
	      ("\M-\d" . vertico-directory-delete-word)))


;;;; Eglot
(defun am5k/get-project-name()
	(file-name-nondirectory (directory-file-name (project-name (project-current)))))
(use-package eglot
  :hook
  (rust-mode . eglot-ensure)
  (lua-mode . eglot-ensure)
  (java-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  :bind (:map eglot-mode-map
	      ("C-c r" . eglot-rename)
	      ("C-c o" . eglot-code-action-organize-imports)
	      ("C-c f" . eglot-format)
	      ("C-c h" . eldoc)
	      ("<f6>" . xref-find-definitions))
  :config
  (add-to-list 'eglot-server-programs `((java-mode java-ts-mode) . ("jdt-language-server" "-data" ,(concat "/Users/imarmole/.cache/eglot/" (am5k/get-project-name) "/" ))))
  )

(use-package java-mode
	:mode (("\\.java$" . java-mode))
	:hook
	(java-mode . tree-sitter-hl-mode)
  :custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

(use-package rust-mode
	:mode ("\\.rs$" . rust-mode)
	:hook
	(rust-mode . tree-sitter-hl-mode)
	:custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

(use-package nix-mode
	;; :ensure t
	:mode "\\.nix$\\'"
	:hook
	(nix-mode . tree-sitter-hl-mode)
	:custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

;;;; Tree Sitter
(use-package tree-sitter)
(use-package tree-sitter-langs
  :after tree-sitter)
;; (setq treesit-language-source-alist
;;    '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;;      (cmake "https://github.com/uyha/tree-sitter-cmake")
;;      (css "https://github.com/tree-sitter/tree-sitter-css")
;;      (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;      (go "https://github.com/tree-sitter/tree-sitter-go")
;;      (html "https://github.com/tree-sitter/tree-sitter-html")
;;      (java "https://github.com/tree-sitter/tree-sitter-java" "master" "src")
;;      (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;      (json "https://github.com/tree-sitter/tree-sitter-json")
;; 		 (nix "https://github.com/nix-community/tree-sitter-nix")
;;      (make "https://github.com/alemuller/tree-sitter-make")
;;      (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;      (python "https://github.com/tree-sitter/tree-sitter-python")
;;      (rust "https://github.com/tree-sitter/tree-sitter-rust")
;;      (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;      (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;      (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;      (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; (setq major-mode-remap-alist
;;  '((yaml-mode . yaml-ts-mode)
;;    (bash-mode . bash-ts-mode)
;;    (java-mode . java-ts-mode)
;;    (js2-mode . js-ts-mode)
;;    (typescript-mode . typescript-ts-mode)
;;    (json-mode . json-ts-mode)
;;    (css-mode . css-ts-mode)
;;    (python-mode . python-ts-mode)
;;    ;; (nix-mode . nix-ts-mode)
;; 	 (rust-mode . rust-ts-mode)))

;; Configure Tempel
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-expand
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
) ;; end tempel

(use-package vterm
	:hook
	(vterm-mode . (lambda() (display-line-numbers-mode 0))))

