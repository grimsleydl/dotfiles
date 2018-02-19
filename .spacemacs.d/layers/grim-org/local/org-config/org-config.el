(require 'org)
;; (require 'org-contacts)
(require 'org-bullets)
(require 'ox-bibtex)
(require 'ox-extra)

(provide 'org-config)

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
(add-hook 'org-mode-hook
          '(lambda ()
             ;; make the lines in the buffer wrap around the edges of the screen.
             ;; (visual-line-mode)
             ;; (auto-fill-mode)
             (spacemacs/toggle-visual-line-navigation-on)
             (spacemacs/toggle-auto-fill-mode-on)
             (org-bullets-mode 1)
             (org-toggle-blocks)
             (set-buffer-variable-pitch)
             ;; (org-indent-mode)
             (setq fill-column 100)
             (spacemacs|diminish buffer-face-mode)
             )
          )
(setq
 completion-at-point-functions
 '(org-completion-symbols
   ora-cap-filesystem
   org-completion-refs))
(setq
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
 org-src-window-setup 'current-window
 org-footnote-auto-label 'random
 org-footnote-define-inline +1
 org-footnote-auto-adjust nil
 org-footnote-section nil

 org-id-link-to-org-use-id t

 org-odt-preferred-output-format "doc"
 org-directory "~/Dropbox/org"
 org-default-notes-file (concat org-directory "/inbox.org")
 org-journal-dir "~/Dropbox/org/journal/"
 org-brain-path "~/Dropbox/org/personal/brain")

(setq org-todo-keywords '((sequence "❢TODO(t!)" "★NEXT(n!)" "⚡ACTIVE(a!)" "|" "✔DONE(d!)" "✘CANCELED(c!)")
                          (sequence "⌚HOLD(h@/!)" "⧖WAITING(w@/!)" "➤DELEGATED(l@/!)" "☎FOLLOWUP(f!)" "SOMEDAY(s!)" "|" "✘CANCELED(c!)")
                          (sequence "PROJ(p)" "|" "✔DONE(d!)" "✘CANCELED(c!)")))
(setq org-todo-state-tags-triggers '(("✘CANCELED" ("CANCELED" . t))
                                     ("⧖WAITING" ("WAITING" . t))
                                     ("⌚HOLD" ("WAITING") ("HOLD" . t))
                                     (done ("WAITING") ("HOLD"))
                                     ("☎FOLLOWUP" ("FOLLOWUP" . t))
                                     ("❢TODO" ("WAITING") ("CANCELED") ("HOLD"))
                                     ("☄NEXT" ("WAITING") ("CANCELED") ("HOLD"))
                                     ("✔DONE" ("WAITING") ("CANCELED") ("HOLD"))))
(setq org-bullets-bullet-list
      '("⊢"
        "❘"
        "¦"
        "╲"
        "⋱"
        "●"
        "○"
        "·"
        ))
;; (setq org-bullets-bullet-list
;;      '(
;;        "●"
;;        "◉"
;;        "◎"
;;        "○"
;;        "✭"
;;        "☆"
;;        "▶"
;;        "▸"
;;        "✿"
;;        "✜"
;;        "⚪"
;;        "◇"
;;        "•"
;;        )

(setq org-list-demote-modify-bullet
      '(("-" . "+")
        ("+" . "-")
        ("1." . "1)")
        ("1)" . "1.")))
(setq
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
 org-indirect-buffer-display 'current-window)

(setq org-capture-templates '(
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
                              ("n"                                 ; key
                               "Note"                              ; name
                               entry                               ; type
                               (file (concat org-directory "/inbox.org"))
                               "* %^{Title}
:PROPERTIES:
:Created: %U
:END:
%i
%?"
                               :kill-buffer t)
                              ;; VIDEO IDEA
                              ("v"                                                         ; key
                               "Video idea"                                                ; name
                               entry                                                       ; type
                               (file+headline "~/Dropbox/org/personal/videos.org" "Notes") ; target
                               "* %^{Title}
:PROPERTIES:
:CREATED: %U
:END:
%i
%?"
                               :kill-buffer t)
                              ;; JOURNAL ENTRY WITH DATE
                              ("j" "Journal entry with date" plain
                               (file+datetree "~/Dropbox/org/personal/journal.org")
                               "%?"
                               )
                              ;; TICKET
                              ("w" "Work ticket with date" plain
                               (file+datetree "~/Documents/work-log.org")
                               "**** ❢TODO %?"
                               )
                              ("b" "Brain" plain (function org-brain-goto-end)
                               "* %i%?" :empty-lines 1)
                              ;; WORK JOURNAL WITH DATE
                              ;; ("jw" "Work journal entry with date" plain
                              ;;  (file+datetree (concat org-directory "/personal/work.org") "Journal")
                              ;;  "%?"
                              ;;  )
                              ))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

(setq org-agenda-files
      (quote
       ("~/Dropbox/org/inbox.org" "~/Dropbox/org/me.org")))

(setq org-agenda-custom-commands
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
         ((org-agenda-sorting-strategy '(user-defined-up))))))
(setq
 ;; org-agenda-cmp-user-defined 'org-age-compare
 org-agenda-span 14
 org-expiry-created-property-name "CREATED" ; Name of property when an item is created
 org-expiry-inactive-timestamps t) ; Don't have everything in the agenda view

;; org-publish-project-alist
;; '(("tutoring handbook"
;;    :base-directory "~/Dropbox/org/STARS/tutoring/"
;;    :base-extension "org"
;;    :publishing-directory "~/Documents/GitHub/starstutoring-handbook/"
;;    :publishing-function org-twbs-publish-to-html
;;    ))

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
