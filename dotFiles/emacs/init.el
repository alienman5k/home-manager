(defvar am5k/emacs-config-file
  (expand-file-name "config.org" user-emacs-directory))

(org-babel-load-file am5k/emacs-config-file)
;; (setq user-full-name "Ignacio Marmolejo"
;;       user-mail-address "ignacio.marmolejo@oracle.com"
;;       user-login-name "imarmole")

;; ;; Straight is used to install packages and use-package is used to configure them
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; ;; Install use-package
;; (straight-use-package 'use-package)

;; ;; Configure use-package to use straight.el by default
;; (use-package straight
;;   :custom
;;   (straight-use-package-by-default t))
;; ;; (setq straight-use-package-by-default t)

;; ;; Load extra modules after use-package is defined
;; (defvar emacs-dir (file-name-directory load-file-name)
;;   "Top level Emacs dir.")
;; (defvar module-dir (expand-file-name "modules" emacs-dir)
;;   "Personal configuration")
;; (defvar save-dir (expand-file-name "cache" emacs-dir)
;;   "Common place to save Emacs save/history-files.")

;; (unless (file-exists-p save-dir)
;;   (make-directory save-dir))

;; (add-to-list 'load-path module-dir)
;; (mapc 'load (directory-files module-dir nil "^[^#].*el$"))


;; (run-with-idle-timer
;;  3 nil
;;  (lambda ()
;;    (let ((inhibit-message t))
;;      (message "Emacs ready in %s with %d garbage collections."
;;               (format "%.2f seconds"
;;                       (float-time
;;                        (time-subtract after-init-time before-init-time)))
;;               gcs-done))))
