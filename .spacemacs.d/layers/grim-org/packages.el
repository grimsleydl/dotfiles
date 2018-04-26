;;; packages.el --- grim-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <dlgrimsley@GL-109297>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `grim-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `grim-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `grim-org/pre-init-PACKAGE' and/or
;;   `grim-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:
(defconst grim-org-packages
  '(
    interleave
    (org-config :location local)
    org-noter
    org-wc
    nanowrimo
    (org-bullets :location (recipe :fetcher github :repo "Kaligule/org-bullets"))
    ;; ox-twbs
    ;; worf
    )
  )
(defun grim-org/init-interleave ()
  (use-package interleave
    :defer t))

(defun grim-org/init-org-bullets ()
  (use-package org-bullets
    :defer t))

(defun grim-org/init-org-noter ()
  (use-package org-noter
    :defer t))

(defun grim-org/init-org-wc ()
  (use-package org-wc
    :defer t))

(defun grim-org/init-nanowrimo ()
  (use-package nanowrimo
    :defer t))

;; (defun grim-org/init-ox-twbs ()
;;   (use-package ox-twbs
;;     :defer t))
;; (defun grim-org/init-worf ()
;;   (use-package worf
;;     :diminish worf-mode
;;     ))
(defun grim-org/init-org-config ()
    (use-package org-config
      :after org))

(defun grim-org/post-init-org ()
  (use-package org
    :defer t
    :config
    ;; http://stackoverflow.com/questions/14351154/org-mode-outline-level-specific-fill-column-values
    (spacemacs|use-package-add-hook grim-org
      :post-config
      (progn (require 'mm-url) ; to include mm-url-decode-entities-string
             ;; Allow automatically handing of created/expired meta data.
             ;; (require 'org-expiry)
             ;; (require 'org-protocol)
             (require 'org-checklist)
             (require 'org-id)
             ;; (require 'ox-extra)
             (org-id-update-id-locations)

             (ox-extras-activate '(ignore-headlines))))
    )
  )
;; '(mapc
;;   (lambda (face)
;;     (set-face-attribute
;;      face nil
;;      :inherit
;;      (my-adjoin-to-list-or-symbol
;;       'fixed-pitch
;;       (face-attribute face :inherit))))
;;   (list 'org-code 'org-block 'org-table 'org-block-background))
;;; packages.el ends here
