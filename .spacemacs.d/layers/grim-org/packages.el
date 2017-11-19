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
  '(org
    org-trello
    org-wc
    nanowrimo
    ;; ox-twbs
    ;; worf
    ;; (org-sendto-medium :location local)
    )
  )


;; (defun grim-org/init-org-sendto-medium ()
;;   (spacemacs|use-package-add-hook org :post-config (require 'org-sendto-medium)))
(defun grim-org/init-org-trello ()
  (use-package org-wc
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

(defun grim-org/post-init-org ()
  (use-package org
    :defer t
    :config
    (setq
     completion-at-point-functions
     '(org-completion-symbols
       ora-cap-filesystem
       org-completion-refs)
     ;; org-adapt-indentation nil
     ;; org-indent-mode t
     org-startup-indented t
     org-edit-src-content-indentation 0
     org-cycle-separator-lines 0
     org-cycle-emulate-tab 'white
     org-M-RET-may-split-line nil
     org-insert-heading-respect-content t
     org-special-ctrl-a/e t
     org-ellipsis " ▽"
     org-enforce-todo-dependencies t
     org-enforce-todo-checkbox-dependencies t
     org-use-speed-commands t
     org-log-into-drawer t
     org-clock-into-drawer t
     org-log-redeadline 'time
     org-log-reschedule 'time

     org-footnote-auto-label 'random
     org-footnote-define-inline +1
     org-footnote-auto-adjust nil
     org-footnote-section nil

     org-id-link-to-org-use-id t

     org-odt-preferred-output-format "doc"
     org-directory "~/Dropbox/org"
     org-default-notes-file (concat org-directory "/inbox.org")
     org-journal-dir "~/Dropbox/org/journal/"
     org-todo-keywords
     '((sequence "❢TODO(t!)" "★NEXT(n!)" "⚡ACTIVE(a!)" "|" "✔DONE(d!)" "✘CANCELED(c!)")
       (sequence "⌚HOLD(h@/!)" "⧖WAITING(w@/!)" "➤DELEGATED(l@/!)" "☎FOLLOWUP(f!)" "SOMEDAY(s!)" "|" "✘CANCELED(c!)")
       (sequence "PROJ(p)" "|" "✔DONE(d!)" "✘CANCELED(c!)"))

     org-todo-state-tags-triggers
     (quote (("✘CANCELED" ("CANCELED" . t))
             ("⧖WAITING" ("WAITING" . t))
             ("⌚HOLD" ("WAITING") ("HOLD" . t))
             (done ("WAITING") ("HOLD"))
             ("☎FOLLOWUP" ("FOLLOWUP" . t))
             ("❢TODO" ("WAITING") ("CANCELED") ("HOLD"))
             ("☄NEXT" ("WAITING") ("CANCELED") ("HOLD"))
             ("✔DONE" ("WAITING") ("CANCELED") ("HOLD"))))
     org-bullets-bullet-list
     '(
       "●"
       "◉"
       "◎"
       "○"
       "✭"
       "☆"
       "▶"
       "▸"
       "✿"
       "✜"
       "⚪"
       "◇"
       "•"
       )
     org-list-demote-modify-bullet '(("-" . "+")
                                     ("+" . "-")
                                     ("1." . "1)")
                                     ("1)" . "1."))
     org-agenda-todo-ignore-scheduled '(future)
     org-agenda-tags-todo-honor-ignore-options nil
     org-bookmark-jump-indirect 't
     org-catch-invisible-edits '(show-and-error)
     org-ctrl-k-protect-subtree 't

     org-tags-exclude-from-inheritance '("project")
     org-refile-use-outline-path 'file
     org-outline-path-complete-in-steps nil
     org-refile-allow-creating-parent-nodes (quote confirm)
     org-refile-targets (quote ((nil :maxlevel . 5)
                                (org-agenda-files :maxlevel . 5)))
     org-agenda-text-search-extra-files '(agenda-archives)

     org-indirect-buffer-display 'current-window

     org-capture-templates
     '(
       ;; NORMAL TODO
       ("t" "todo" entry
        (file (concat org-directory "/inbox.org"))
        "* ❢TODO %^{Description}
:PROPERTIES:
:Created: %U
:END:
%?"
        :kill-buffer t
        :created)
       ;; PLAIN NOTE INTO INBOX
       ("n"               ; key
        "Note"            ; name
        entry             ; type
        (file (concat org-directory "/inbox.org"))
        "* %^{Title}
:PROPERTIES:
:Created: %U
:END:
%i
%?"
        :kill-buffer t)
       ;; VIDEO IDEA
       ("v"               ; key
        "Video idea"            ; name
        entry             ; type
        (file+headline "~/Dropbox/org/personal/videos.org" "Notes")  ; target
        "* %^{Title}
:PROPERTIES:
:CREATED: %U
:END:
%i
%?"
        :kill-buffer t)
       ("j" "Journal entries")
       ;; JOURNAL ENTRY WITH DATE
       ("jh" "Journal entry with date" plain
        (file+datetree (concat org-directory "/personal/journal.org"))
        "%?"
        )
       ;; WORK JOURNAL WITH DATE
       ("jw" "Work journal entry with date" plain
        (file+datetree (concat org-directory "/STARS/stars.org") "Journal")
        "%?"
        )
       )
     org-refile-target-verify-function 'bh/verify-refile-target
     org-agenda-files
     (quote
      ("~/Dropbox/org/inbox.org" "~/Dropbox/org/STARS/stars.org" "~/Dropbox/org/me.org"))
     org-agenda-custom-commands
     ;; The " " here is the shortcut for this agenda, so `C-c a SPC` or `, a SPC'
     '((" " "Agenda"
        ((agenda "" nil)
         ;; All items with the "REFILE" tag, everything in refile.org
         ;; automatically gets that applied
         (tags "REFILE"
               ((org-agenda-overriding-header "Tasks to Refile")
                (org-tags-match-list-sublevels nil)))
         ;; All "⚡ACTIVE" todo items
         (todo "⚡ACTIVE"
               ((org-agenda-overriding-header "Current work")))
         ;; All "★NEXT" todo items
         (todo "★NEXT"
               ((org-agenda-overriding-header "Next actions")))
         ;; All headings with the "support" tag
         ;; (tags "support/!"
         ;;       ((org-agenda-overriding-header "Support cases")))
         ;; All "➤DELEGATED" todo items
         (todo "➤DELEGATED"
               ((org-agenda-overriding-header "Waiting on someone")))
         ;; All "WAITING" items without a "support" tag
         (todo "⧖WAITING"
               ((org-agenda-overriding-header "Waiting for something")))
         ;; All headings with the "recurring" tag
         (tags "recurring/!"
               ((org-agenda-overriding-header "Recurring")))
         ;; All ❢TODO items
         (todo "❢TODO"
               ((org-agenda-overriding-header "Task list")
                ;; sort by time, priority, and category
                (org-agenda-sorting-strategy
                 '(time-up priority-down category-keep))))
         ;; Everything on hold
         (todo "⌚HOLD"
               ((org-agenda-overriding-header "On-hold")))
         )
        nil)
       ("z" "sort by age"
        todo "TODO"
        ((org-agenda-sorting-strategy '(user-defined-up))))
       ;; ("n" "errands" tags-todo "+errand")
       ;; ("o" "office" tags-todo "+office")
       ;; ("h" "home" tags-todo "+home")
       )
     ;; org-agenda-cmp-user-defined 'org-age-compare
     org-agenda-span 14
     org-expiry-created-property-name "CREATED" ; Name of property when an item is created
     org-expiry-inactive-timestamps   t         ; Don't have everything in the agenda view

     ;; org-publish-project-alist
     ;; '(("tutoring handbook"
     ;;    :base-directory "~/Dropbox/org/STARS/tutoring/"
     ;;    :base-extension "org"
     ;;    :publishing-directory "~/Documents/GitHub/starstutoring-handbook/"
     ;;    :publishing-function org-twbs-publish-to-html
     ;;    ))
     )

    ;; http://stackoverflow.com/questions/14351154/org-mode-outline-level-specific-fill-column-values
    ;; (add-hook 'org-load-hook 'my-org-mode-hook)
    ;; (add-hook 'org-mode-hook 'my-org-mode-hook)

    ;; (add-hook 'org-mode-hook
    ;;           (lambda()
    ;;             (add-hook 'after-save-hook 'grim-org/reflash-indentation)))

    ;; (add-hook 'window-configuration-change-hook 'nanny/org-realign-tag-column)
    (add-hook 'org-capture-mode-hook 'evil-insert-state)
    (add-hook 'org-agenda-mode-hook
              (lambda ()
                (vim-empty-lines-mode -1)
                ))
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

    (defconst org-age-property "CREATED")

    ;; (org-add-link-type "outlook" 'org-outlook-open)

    ;; (defun org-outlook-open (id)
    ;;   "Open the Outlook item identified by ID.  ID should be an Outlook GUID."
    ;;   (w32-shell-execute "open" "outlook" (concat "outlook:" id)))

    ;; (provide 'org-outlook)

    (defadvice org-archive-subtree
        (before add-inherited-tags-before-org-archive-subtree activate)
      "add inherited tags before org-archive-subtree"
      (org-set-tags-to (org-get-tags-at)))

    ;; counsel and org
    (defface modi/counsel-org-goto-level-1 '((t . (:inherit org-level-1 :weight normal)))
      "Face for Level 1 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-2 '((t . (:inherit org-level-2 :weight normal)))
      "Face for Level 2 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-3 '((t . (:inherit org-level-3 :weight normal)))
      "Face for Level 3 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-4 '((t . (:inherit org-level-4 :weight normal)))
      "Face for Level 4 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-5 '((t . (:inherit org-level-5 :weight normal)))
      "Face for Level 5 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-6 '((t . (:inherit org-level-6 :weight normal)))
      "Face for Level 6 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-7 '((t . (:inherit org-level-7 :weight normal)))
      "Face for Level 7 in `counsel-org-goto'.")
    (defface modi/counsel-org-goto-level-8 '((t . (:inherit org-level-8 :weight normal)))
      "Face for Level 8 in `counsel-org-goto'.")

    (setq counsel-org-goto-face-style 'custom)
    (setq counsel-org-goto-custom-faces '(modi/counsel-org-goto-level-1
                                          modi/counsel-org-goto-level-2
                                          modi/counsel-org-goto-level-3
                                          modi/counsel-org-goto-level-4
                                          modi/counsel-org-goto-level-5
                                          modi/counsel-org-goto-level-6
                                          modi/counsel-org-goto-level-7
                                          modi/counsel-org-goto-level-8))

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
