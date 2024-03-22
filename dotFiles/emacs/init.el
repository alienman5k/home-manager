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
		    :font "BlexMono Nerd Font"
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

(load-theme 'doom-one 1)
;; (load-theme 'ef-light 1)
;; (use-package ef-themes)
;; (use-package ef-themes
;;   :config
;;   (ef-themes-select 'ef-light t))

;; (defun am5k/apply-system-theme(appearance)
;;   "Apply a light or dark theme depending on the APPEARANCE of the system."
;;   (mapc #'disable-theme custom-enabled-themes)
;;   (pcase appearance
;;     ('light (load-theme ef-light t))
;;     ('dark (load-theme ef-night t))))

;; (add-hook 'ns-system-appearance-change-functions #'am5k/apply-system-theme)
 
(use-package which-key
  :config
  (which-key-mode 1))

;;; Customize org-mode
(use-package org
  :mode (("\\.org$" . org-mode))
  ;;:ensure org-plus-contrib
	:init
	(custom-theme-set-faces
	 'user
	 `(org-level-1 ((t (:inherit outline-1 :height 1.3))))
	 `(org-level-2 ((t (:inherit outline-2 :height 1.2))))
	 `(org-level-3 ((t (:inherit outline-3 :height 1.15))))
	 `(org-level-4 ((t (:inherit outline-4 :height 1.1))))
	 `(org-level-5 ((t (:inherit outline-5 :height 1.0)))))
  :custom
  (org-edit-src-content-indentation 0)
  (org-ellipsis " ↘")
  (org-export-backends '(ascii html odt md))
	(org-hide-leading-stars 1)
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

;;;; General
(use-package general
  :after evil
  :config
  (general-define-key
   :states 'normal
   :prefix "SPC"
   "" '(nil :which-key "Leader Key")
   "f" '(:ignore t :which-key "File")
   "ff" 'find-file
   "fs" 'save-buffer
   "fn" 'evil-buffer-new
   "fg" 'consult-find
   "b" '(:ignore t :which-key "Buffer")
   "bb" 'consult-buffer
   "bn" 'evil-next-buffer
   "bp" 'evil-prev-buffer
   "h" '(:keymap help-map :which-key "Help")
   "ht" 'consult-theme
   ;; "hf" 'helpful-callable
   ;; "hk" 'helpful-key
   ;; "ho" 'helpful-symbol
   ;; "hv" 'helpful-variable
	 "o" '(:ignore t :which-key "Org Roam")
	 "ot" 'org-roam-buffer-toggle
   "of" 'org-roam-node-find
   "oi" 'org-roam-node-insert
   "s" '(:keymap search-map :which-key "Search")
   ;; "s" '(:ignore t :which-key "Search")
   "sl" 'consult-line
   "sg" 'consult-grep
   "p" '(:keymap project-prefix-map :which-key "Project")
   ;; "p" '(:ignore t :which-key "Project")
   ;; "pp" 'project-switch-project
   ;; "pf" 'project-find-file
   ;; "pd" 'project-dired
   ;; "ps" 'project-shell
   "t" '(:ignore t :which-key "Tabs")
   "tt" 'tab-new
   "tn" 'tab-next
   "tp" 'tab-previous
   "tc" 'tab-close
   "tm" 'tab-move
   "tr" 'tab-rename))

;;;; Orderless
(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;;; Corfu (COmpletion in Region Function): This is the UI that shows completions
(use-package corfu
  :custom
  (corfu-separator ?\s) ;; Orderless field separator               
  (corfu-cycle t)	;; Enable cycling for `corfu-next/previous'  
  :init
  (global-corfu-mode))

;; Completion at Point Extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
	:hook ((org-mode . org-cape-setup))
  :bind (("C-c p p" . completion-at-point) ;; capf
         ;; ("M-<tab>" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
	(defun common-cape-setup ()
		(add-to-list 'completion-at-point-functions #'cape-dabbrev)
		(add-to-list 'completion-at-point-functions #'cape-file))
	(defun org-cape-setup () 
		(add-to-list 'completion-at-point-functions #'cape-dabbrev)
		(add-to-list 'completion-at-point-functions #'cape-file)
		(add-to-list 'completion-at-point-functions #'cape-dict))
)

;;;; Vertico
(use-package vertico
  :init (vertico-mode 1)
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind (:map vertico-map
	      ("\r" . vertico-directory-enter)
	      ("\d" . vertico-directory-delete-char)
	      ("\M-\d" . vertico-directory-delete-word))
  :config
  (setq vertico-cycle t)
  ;;; History mode
  (savehist-mode t)
  (save-place-mode 1)
  (recentf-mode 1))

;; (use-package vertico-directory
;;   ;; :straight nil
;;   :load-path "straight/build/vertico/extensions/"
;;   :after vertico
;;   ;; this adds -hook explicitly so we need to remove the -hook portion
;;   :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
;;   :bind (:map vertico-map
;; 	      ("\r" . vertico-directory-enter)
;; 	      ("\d" . vertico-directory-delete-char)
;; 	      ("\M-\d" . vertico-directory-delete-word)))


;;;; Eglot
(defun am5k/get-project-name()
	(file-name-nondirectory (directory-file-name (project-name (project-current)))))
(use-package eglot
  :hook
  (rust-mode . eglot-ensure)
  (lua-mode . eglot-ensure)
  ;; (java-mode . eglot-ensure)
  (json-mode . eglot-ensure)
  (json-ts-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  :bind (:map eglot-mode-map
	      ("C-c r" . eglot-rename)
	      ("C-c o" . eglot-code-action-organize-imports)
	      ("C-c f" . eglot-format)
	      ("C-c h" . eldoc)
	      ("<f6>" . xref-find-definitions))
  :config
  (add-to-list 'eglot-server-programs `((java-mode java-ts-mode) . ("jdtls" "-data" ,(concat "/Users/imarmole/.cache/eglot/" (am5k/get-project-name) "/" ))))
  )

(use-package java-mode
	:mode (("\\.java$" . java-mode))
	;; :hook
	;; (java-mode . tree-sitter-hl-mode)
  :custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

(use-package rust-mode
	:mode ("\\.rs$" . rust-mode)
	;; :hook
	;; (rust-mode . tree-sitter-hl-mode)
	:custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

;; (use-package markdown-mode
;; 	:mode ("\\.md\\'" . gfm-mode))

;; (use-package json-mode
;; 	:mode ("\\.json$" . json-mode)
;; 	:hook (hs-minor-mode . json-mode)
;; 	;; :init
;; 	;; (when (not (treesit-install-language-grammar 'json))
;; 	;; 	(treesit-install-language-grammar 'json))
;; 	:custom
;;   (c-basic-offset 2)
;;   (tab-width 2)
;;   (indent-tabs-mode nil))

(use-package json-ts-mode
 	:mode ("\\.json$" . json-ts-mode)
	;; :hook (json-ts-mode . hs-minor-mode)
	:custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode nil))

(use-package nix-mode
	:mode "\\.nix$\\'"
	;; :hook
	;; (nix-mode . tree-sitter-hl-mode)
	:custom
  (c-basic-offset 2)
  (tab-width 2)
  (indent-tabs-mode t))

;;;; Tree Sitter
;; (use-package tree-sitter)
;; (use-package tree-sitter-langs
;;   :after tree-sitter)

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (java "https://github.com/tree-sitter/tree-sitter-java" "master" "src")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
		 (nix "https://github.com/nix-community/tree-sitter-nix")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
 '((yaml-mode . yaml-ts-mode)
   (bash-mode . bash-ts-mode)
   (java-mode . java-ts-mode)
   (js2-mode . js-ts-mode)
   (typescript-mode . typescript-ts-mode)
   (json-mode . json-ts-mode)
   (css-mode . css-ts-mode)
   (python-mode . python-ts-mode)
   ;; (markdown-mode . markdown-ts-mode)
   (nix-mode . nix-ts-mode)
	 (rust-mode . rust-ts-mode)))

;; (setq treesit-enabled-langs-alist
;; 			(bash elisp html java javascript json nix rust))
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))
;; (add-hook 'hs-minor-mode-hook #'json-ts-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)

;; Configure Tempel
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert)
				 :map tempel-map
				 ("C-j" . tempel-next)
				 ("C-k" . tempel-previous))
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

(use-package tempel-collection
	:after tempel)

(use-package eglot-tempel
	:after eglot)

(use-package vterm
	:hook
	(vterm-mode . (lambda() (display-line-numbers-mode 0))))


(use-package org-roam
  :custom 
  (org-roam-directory "~/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n C-l" . org-store-link)
         ("C-c n l" . org-insert-link))
  :config
  (org-roam-setup))
