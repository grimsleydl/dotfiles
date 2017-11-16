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
       drag-stuff
       git-auto-commit-mode
      ))

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
