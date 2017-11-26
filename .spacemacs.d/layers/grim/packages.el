;;; packages.el --- grim Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq grim-packages
     '(
;;       draft-mode
;;       fancy-narrow
;;       focus
;;       olivetti
;;       org-bookmark-heading
;;       org-journal
;;       writegood-mode
;;       ;; vimish-fold
;;       ;; evil-vimish-fold
       dired-collapse
       diredfl
       ;; dired-k
       dired-narrow
       dired-quick-sort
       ;; dired-rainbow
       dired-subtree
       drag-stuff
       ;; dired+
       git-auto-commit-mode
       sx
       zoom
      ))
(defun grim/init-zoom ()
  "Initialize zoom"
  (use-package zoom))

(defun grim/init-sx ()
  "Initialize sx"
  (use-package sx
    :config
    (;; bind-keys :prefix "C-c s"
     ;;           :prefix-map my-sx-map
     ;;           :prefix-docstring "Global keymap for SX."
     ;;           ("q" . sx-tab-all-questions)
     ;;           ("i" . sx-inbox)
     ;;           ("o" . sx-open-link)
     ;;           ("u" . sx-tab-unanswered-my-tags)
     ;;           ("a" . sx-ask)
     ;;           ("s" . sx-search)
               ))
    )
(defun grim/init-diredfl ()
  "Initialize dired-k"
  (use-package diredfl
    :after dired
    ;; :config
    ;; (setq dired-k-human-readable t)
    ;; (add-hook 'dired-initial-position-hook 'dired-k)
    ))

(defun grim/init-dired-k ()
  "Initialize dired-k"
  (use-package dired-k
    :after dired
    :config
    (setq dired-k-human-readable t)
    (add-hook 'dired-initial-position-hook 'dired-k)
    ))

(defun grim/init-dired-collapse ()
  "Initialize dired-collapse"
  (use-package dired-collapse
  ;; :ensure t
  :after dired
  :config
  (add-hook 'dired-after-readin-hook 'dired-collapse-mode)
  ))

(defun grim/init-dired-rainbow ()
  "Initialize dired-rainbow"
  (use-package dired-rainbow))

(defun grim/init-dired-narrow ()
  "Initialize dired-narrow"
  (use-package dired-narrow))

;; (defun grim/init-dired+ ()
;;   "Initialize dired+"
;;   (use-package dired+
;;     :config
;;     (setq diredp-hide-details-initially-flag nil)))

(defun grim/init-dired-quick-sort ()
  "Initialize dired-quick-sort"
  (use-package dired-quick-sort
    :init (dired-quick-sort-setup)))

(defun grim/init-dired-subtree ()
  (use-package dired-subtree
    :ensure t
    :after dired
    :config
    (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
    (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map)))

(defun grim/init-git-auto-commit-mode ()
  (use-package git-auto-commit-mode))

(defun grim/init-drag-stuff ()
  (use-package drag-stuff
    :config
    (progn
      (setq drag-stuff-except-modes '(org-mode emacs-lisp-mode clojure-mode))
      (drag-stuff-global-mode t))))

;; List of packages to exclude.
;; (setq grim-excluded-packages '())

;; For each package, define a function grim/init-<package-name>
;;
;; (defun grim/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
;; (defun grim/init-draft-mode ()
;;   :defer t
;;     )

;; (defun grim/init-draft-mode ()
;;   (use-package draft-mode
;;   :defer t)
;;   )

;; (defun grim/init-fancy-narrow ()
;;   (use-package fancy-narrow
;;   :defer t)
;;   )

;; (defun grim/init-focus ()
;;   (use-package focus
;;   :defer t)
;;   )

;; (defun grim/init-olivetti ()
;;   (use-package olivetti
;;   :defer t)
;;   )

;; (defun grim/init-org-bookmark-heading ()
;;   (use-package org-bookmark-heading
;;     :defer t)
;;   )
;; (defun grim/init-org-journal ()
;;   (use-package org-journal
;;   :defer t)
;;   )

;; (defun grim/init-writegood-mode ()
;;   (use-package writegood-mode
;;   :defer t))

;; (defun grim/vimish-fold ()
;;   (use-package vimish-fold
;;     :defer t
;;     :config (vimish-fold-global-mode t)))

;; (defun grim/evil-vimish-fold ()
;;   (use-package evil-vimish-fold
;;   :defer t)
;;   )
