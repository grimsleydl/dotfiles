(defun org-completion-symbols ()
  (when (looking-back "=[a-zA-Z]+")
    (let (cands)
      (save-match-data
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "=\\([a-zA-Z]+\\)=" nil t)
            (cl-pushnew
             (match-string-no-properties 0) cands :test 'equal))
          cands))
      (when cands
        (list (match-beginning 0) (match-end 0) cands)))))

(defvar org-blocks-hidden nil)
(defun org-toggle-blocks ()
  (interactive)
  (if org-blocks-hidden
      (org-show-block-all)
    (org-hide-block-all))
  (setq-local org-blocks-hidden (not org-blocks-hidden)))


(defun hot-expand (str)
  "Expand org template."
  (insert str)
  (org-try-structure-completion))

(defun jk/unlinkify ()
  "Replace an org-link with the description, or if this is absent, the path."
  (interactive)
  (let ((eop (org-element-context)))
    (when (eq 'link (car eop))
      (message "%s" eop)
      (let* ((start (org-element-property :begin eop))
             (end (org-element-property :end eop))
             (contents-begin (org-element-property :contents-begin eop))
             (contents-end (org-element-property :contents-end eop))
             (path (org-element-property :path eop))
             (desc (and contents-begin
                        contents-end
                        (buffer-substring contents-begin contents-end))))
        (setf (buffer-substring start end)
              (concat (or desc path)
                      (make-string (org-element-property :post-blank eop) ?\s)))))))

(defun my/org-word-count (beg end
                           &optional count-latex-macro-args?
                           count-footnotes?)
  "Report the number of words in the Org mode buffer or selected region.
Ignores:
- comments
- tables
- source code blocks (#+BEGIN_SRC ... #+END_SRC, and inline blocks)
- hyperlinks (but does count words in hyperlink descriptions)
- tags, priorities, and TODO keywords in headers
- sections tagged as 'not for export'.

The text of footnote definitions is ignored, unless the optional argument
COUNT-FOOTNOTES? is non-nil.

If the optional argument COUNT-LATEX-MACRO-ARGS? is non-nil, the word count
includes LaTeX macro arguments (the material between {curly braces}).
Otherwise, and by default, every LaTeX macro counts as 1 word regardless
of its arguments."
  (interactive "r")
  (unless mark-active
    (setf beg (point-min)
          end (point-max)))
  (let ((wc 0)
        (latex-macro-regexp "\\\\[A-Za-z]+\\(\\[[^]]*\\]\\|\\){\\([^}]*\\)}"))
    (save-excursion
      (goto-char beg)
      (while (< (point) end)
        (cond
         ;; Ignore comments.
         ((or (evil-in-comment-p) (org-at-table-p))
          nil)
         ;; Ignore hyperlinks. But if link has a description, count
         ;; the words within the description.
         ((looking-at org-bracket-link-analytic-regexp)
          (when (match-string-no-properties 5)
            (let ((desc (match-string-no-properties 5)))
              (save-match-data
                (incf wc (length (remove "" (org-split-string
                                             desc "\\W")))))))
          (goto-char (match-end 0)))
         ((looking-at org-any-link-re)
          (goto-char (match-end 0)))
         ;; ;; Ignore source code blocks.
         ;; ((org-in-regexps-block-p "^#\\+BEGIN_SRC\\W" "^#\\+END_SRC\\W")
         ;;  nil)
         ;; Ignore inline source blocks, counting them as 1 word.
         ;; ((save-excursion
         ;;    (backward-char)
         ;;    (looking-at org-babel-inline-src-block-regexp))
         ;;  (goto-char (match-end 0))
         ;;  (setf wc (+ 2 wc)))
         ;; Count latex macros as 1 word, ignoring their arguments.
         ((save-excursion
            (backward-char)
            (looking-at latex-macro-regexp))
          (goto-char (if count-latex-macro-args?
                         (match-beginning 2)
                       (match-end 0)))
          (setf wc (+ 2 wc)))
         ;; Ignore footnotes.
         ((and (not count-footnotes?)
               (or (org-footnote-at-definition-p)
                   (org-footnote-at-reference-p)))
          nil)
         (t
          (let ((contexts (org-context)))
            (cond
             ;; Ignore tags and TODO keywords, etc.
             ((or (assoc :todo-keyword contexts)
                  (assoc :priority contexts)
                  (assoc :keyword contexts)
                  (assoc :checkbox contexts))
              nil)
             ;; Ignore sections marked with tags that are
             ;; excluded from export.
             ((assoc :tags contexts)
              (if (intersection (org-get-tags-at) org-export-exclude-tags
                                :test 'equal)
                  (org-forward-same-level 1)
                nil))
             (t
              (incf wc))))))
        (re-search-forward "\\w+\\W*")))
    (message (format "%d words in %s." wc
                     (if mark-active "region" "buffer")))))

(defun my/open-tree-view ()
  "Open a clone of the current buffer to the left, resize it to 30 columns, and bind <mouse-1> to jump to the same position in the base buffer."
  (interactive)
  (let ((new-buffer-name (concat "<tree>" (buffer-name))))
    ;; Create tree buffer
    (split-window-right 30)
    (if (get-buffer new-buffer-name)
        (switch-to-buffer new-buffer-name)  ; Use existing tree buffer
      ;; Make new tree buffer
      (progn  (clone-indirect-buffer new-buffer-name nil t)
              (switch-to-buffer new-buffer-name)
              (read-only-mode)
              (hide-body)
              (toggle-truncate-lines)

              ;; Do this twice in case the point is in a hidden line
              (dotimes (_ 2 (forward-line 0)))

              ;; Map keys
              ;; (use-local-map (copy-keymap org-mode-map))
              ;; (local-set-key (kbd "q") 'delete-window)
              ;; (local-set-key (kbd "RET") 'my/jump-to-point-and-show)
              ;; (local-set-key (kbd "<mouse-1>") 'my/jump-to-point-and-show)
              (buffer-local-set-key (kbd "q") 'spacemacs/delete-window)
              (buffer-local-set-key (kbd "RET") 'my/jump-to-point-and-show)
              (buffer-local-set-key (kbd "<mouse-1>") 'my/jump-to-point-and-show))
      )))

(defun my/jump-to-point-and-show ()
  "Switch to a cloned buffer's base buffer and move point to the cursor position in the clone."
  (interactive)
  (let ((buf (buffer-base-buffer)))
    (unless buf
      (error "You need to be in a cloned buffer!"))
    (let ((pos (point))
          (win (car (get-buffer-window-list buf))))
      (if win
          (select-window win)
        (other-window 1)
        (switch-to-buffer buf))
      (goto-char pos)
      (when (invisible-p (point))
        (show-branches)))))

(defun org-refile-to-datetree ()
  "Refile a subtree to a datetree corresponding to it's timestamp."
  (interactive)
  (let* ((datetree-date (org-entry-get nil "TIMESTAMP" t))
         (date (org-date-to-gregorian datetree-date)))
    (when date
      (save-excursion
        (org-cut-subtree)
        (org-datetree-find-date-create date)
        (org-narrow-to-subtree)
        (show-subtree)
        (org-end-of-subtree t)
        (newline)
        (goto-char (point-max))
        (org-paste-subtree 4)
        (widen)
        )
      )
    ))

(defun grim/org-fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'grim/org-fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'org-fill-paragraph)))

;; https://lists.gnu.org/archive/html/emacs-orgmode/2014-05/msg01317.html
(defun org-footnote-inline-footnotes ()
  "Convert external footnotes into inline ones."
  (interactive)
  (org-with-wide-buffer
   (let ((random-labels (make-hash-table :test #'equal)) failed seen)
     (goto-char (point-min))
     (while (re-search-forward org-footnote-re nil t)
       (let ((context (save-excursion (backward-char) (org-element-context))))
         ;; Ignore false positives.
         (when (eq (org-element-type context) 'footnote-reference)
           (let ((label (org-element-property :label context)))
             ;; Ignore anonymous footnotes.
             (when label
               (if (member label seen)
                   (let ((normalized-label (gethash label random-labels)))
                     (when normalized-label
                       (search-backward "[" nil t)
                       (forward-char)
                       (insert normalized-label)
                       (delete-region
                        (point)
                        (progn (skip-chars-forward "0-9") (point)))))
                 (push label seen)
                 (when (eq (org-element-property :type context) 'standard)
                   (let ((beg (copy-marker (org-element-property :begin
                                                                 context)))
                         (end (copy-marker
                               (save-excursion
                                 (goto-char (org-element-property :end context))
                                 (skip-chars-backward " \t")
                                 (point))))
                         (definition
                           (save-excursion
                             (goto-char (point-min))
                             (catch 'exit
                               (while (re-search-forward
                                       (format "^\\[%s\\]" (regexp-quote label))
                                       nil t)
                                 (let ((def (save-excursion
                                              (backward-char)
                                              (org-element-at-point))))
                                   (when (eq (org-element-type def)
                                             'footnote-definition)
                                     (let ((cbeg (org-element-property
                                                  :contents-begin def))
                                           (cend (org-element-property
                                                  :contents-end def)))
                                       ;; Ensure definition can be inline,
                                       ;; i.e., contains a single
                                       ;; paragraph. Return nil if it
                                       ;; cannot.
                                       (if (not cbeg) (throw 'exit "")
                                         (goto-char cbeg)
                                         (let ((contents
                                                (org-element-at-point)))
                                           (if (or (not (eq (org-element-type
                                                             contents) 'paragraph))
                                                   (< (org-element-property
                                                       :end contents) cend))
                                               (throw 'exit nil)
                                             (throw 'exit
                                                    (prog1 (org-trim
                                                            (buffer-substring cbeg cend))
                                                      (delete-region
                                                       (org-element-property
                                                        :begin def)
                                                       (org-element-property
                                                        :end def)))))))))))))))
                     (if (not definition) (push label failed)
                       (delete-region beg end)
                       (goto-char beg)
                       ;; Convert [1] to [fn:random-id] to avoid
                       ;; confusion between [1] and [fn:1].
                       (let ((normalized-label
                              (if (not (org-string-match-p "\\`[0-9]+\\'"
                                                           label))
                                  label
                                (require 'org-id)
                                (puthash
                                 label
                                 (concat "fn:" (substring (org-id-uuid) 0 8))
                                 random-labels))))
                         (insert "[" normalized-label ":" definition "]")))
                     (set-marker beg nil)
                     (set-marker end nil)))))))))
     (cond (failed (user-error "Some footnotes could not be converted : %s"
                               (mapconcat #'identity failed ", ")))
           ;; If process completed without failure, there is no regular
           ;; footnote definition left, so we remove footnote sections,
           ;; if any.
           (org-footnote-section
            (goto-char (point-min))
            (let ((section-re (concat "^\\*+ " org-footnote-section "[ \t]*$")))
              (while (re-search-forward section-re nil t)
                (delete-region (match-beginning 0) (org-end-of-subtree t t))))))
     (message "Footnotes successfully inlined."))))
(fset 'org-footnote-convert-next-to-inline
   [?s ?n ?: escape ?, ?, ?D ?0 ?, ?, ?f ?\] ?i ?: ?  escape ?p escape])

;; http://stackoverflow.com/questions/14351154/org-mode-outline-level-specific-fill-column-values
;; (defun my-org-mode-hook ()
;;   (setq fill-paragraph-function   'my-org-fill-paragraph
;;         normal-auto-fill-function 'my-org-auto-fill-function))

;; (defun calc-offset-on-org-level ()
;;   "Calculate offset (in chars) on current level in org mode file."
;;   (* (or (org-current-level) 0) org-indent-indentation-per-level))

;; (defun my-org-fill-paragraph (&optional JUSTIFY)
;;   "Calculate apt fill-column value and fill paragraph."
;;   (let* ((fill-column (- fill-column (calc-offset-on-org-level))))
;;     (org-fill-paragraph JUSTIFY)))

;; (defun my-org-auto-fill-function ()
;;   "Calculate apt fill-column value and do auto-fill"
;;   (let* ((fill-column (- fill-column (calc-offset-on-org-level))))
;;     (org-auto-fill-function)))

(defun sk/mark-inside-subtree ()
  (interactive)
  (org-mark-subtree)
  (next-line 1))

(defun org-schedule-effort ()
(interactive)
  (save-excursion
    (org-back-to-heading t)
    (let* (
        (element (org-element-at-point))
        (effort (org-element-property :EFFORT element))
        (scheduled (org-element-property :scheduled element))
        (ts-year-start (org-element-property :year-start scheduled))
        (ts-month-start (org-element-property :month-start scheduled))
        (ts-day-start (org-element-property :day-start scheduled))
        (ts-hour-start (org-element-property :hour-start scheduled))
        (ts-minute-start (org-element-property :minute-start scheduled)) )
      (org-schedule nil (concat
        (format "%s" ts-year-start)
        "-"
        (if (< ts-month-start 10)
          (concat "0" (format "%s" ts-month-start))
          (format "%s" ts-month-start))
        "-"
        (if (< ts-day-start 10)
          (concat "0" (format "%s" ts-day-start))
          (format "%s" ts-day-start))
        " "
        (if (< ts-hour-start 10)
          (concat "0" (format "%s" ts-hour-start))
          (format "%s" ts-hour-start))
        ":"
        (if (< ts-minute-start 10)
          (concat "0" (format "%s" ts-minute-start))
          (format "%s" ts-minute-start))
        "+"
        effort)) )))

(defun my/org-agenda-current-subtree-or-region (prefix)
    "Display an agenda view for the current subtree or region.
With prefix, display only TODO-keyword items."
    (interactive "p")
    (let (header)
      (if (use-region-p)
          (progn
            (setq header "Region")
            (put 'org-agenda-files 'org-restrict (list (buffer-file-name (current-buffer))))
            (setq org-agenda-restrict (current-buffer))
            (move-marker org-agenda-restrict-begin (region-beginning))
            (move-marker org-agenda-restrict-end
                         (save-excursion
                           ;; If point is at beginning of line, include heading on that line by moving point forward 1 char
                           (goto-char (1+ (region-end)))
                           (org-end-of-subtree))))
        (progn
          ;; No region; restrict to subtree
          (setq header "Subtree")
          (org-agenda-set-restriction-lock 'subtree)))

      ;; Sorting doesn't seem to be working, but the header is
      (let ((org-agenda-sorting-strategy '(priority-down timestamp-up))
            (org-agenda-overriding-header header))
        (org-search-view (if (>= prefix 4) t nil) "*"))
      (org-agenda-remove-restriction-lock t)
      (message nil)))

(defun my/org-zoom-in ()
  (outline-next-visible-heading)
  (org-narrow-to-subtree))
(defun my/org-zoom-out ()
  (widen)
  (outline-up-heading)
  (org-narrow-to-subtree))

(defun grim-org/reflash-indentation ()
  "Fix org-indent issues, center line, reenable org-mode (fixes indirect buffer breaking)"
  (interactive)
  (org-indent-mode -1)
  (org-indent-mode 1)
  (recenter-top-bottom)
  (org-mode)
  )

(defun my/org-refile-and-jump ()
  (interactive)
  (if (derived-mode-p 'org-capture-mode)
      (org-capture-refile)
    (call-interactively 'org-refile))
  (org-refile-goto-last-stored))
;; (eval-after-load 'org-capture
;;   '(bind-key "C-c C-r" 'my/org-refile-and-jump org-capture-mode-map))

(defun air--org-swap-tags (tags)
  "Replace any tags on the current headline with TAGS.

The assumption is that TAGS will be a string conforming to Org Mode's
tag format specifications, or nil to remove all tags."
  (let ((old-tags (org-get-tags-string))
        (tags (if tags
                  (concat " " tags)
                "")))
    (save-excursion
      (beginning-of-line)
      (re-search-forward
       (concat "[ \t]*" (regexp-quote old-tags) "[ \t]*$")
       (line-end-position) t)
      (replace-match tags)
      (org-set-tags t))))

(defun air-org-set-tags (tag)
  "Add TAG if it is not in the list of tags, remove it otherwise.

TAG is chosen interactively from the global tags completion table."
  (interactive
   (list (let ((org-last-tags-completion-table
                (if (derived-mode-p 'org-mode)
                    (org-uniquify
                     (delq nil (append (org-get-buffer-tags)
                                       (org-global-tags-completion-table))))
                  (org-global-tags-completion-table))))
           (org-icompleting-read
            "Tag: " 'org-tags-completion-function nil nil nil
            'org-tags-history))))
  (let* ((cur-list (org-get-tags))
         (new-tags (mapconcat 'identity
                              (if (member tag cur-list)
                                  (delete tag cur-list)
                                (append cur-list (list tag)))
                              ":"))
         (new (if (> (length new-tags) 1) (concat " :" new-tags ":")
                nil)))
    (air--org-swap-tags new)))

(defun nanny/org-realign-tag-column ()
  (interactive)
  (if (and (equal major-mode 'org-mode)
           (org-get-buffer-tags))
      ;; ignore `message' with flet so org-set-tags doesn't yell at us.
      (cl-flet ((message (&rest args) 'ignore))
        (let ((col (- (- (window-width) 3)))
              (already-modified? (buffer-modified-p)))
          (setq org-tags-column col)
          (org-set-tags 4 t)
          ;; `org-set-tags' modifies the buffer, but I don't really care, so
          ;; mark the buffer as unmodified if it was unmodified previously.
          (if (not already-modified?)
              (set-buffer-modified-p nil))))))

(defun my/org-rename-tree-to-indirect-buffer (&rest args)
  "Rename the new buffer to the current org heading after using org-tree-to-indirect-buffer."
  (with-current-buffer (car (buffer-list (car (frame-list))))
    (save-excursion
      (let* ((heading (nth 4 (org-heading-components)))
             (name (if (string-match org-bracket-link-regexp heading)
                       ;; Heading is an org link; use link name
                       (match-string 3 heading)
                     ;; Not a link; use whole heading
                     heading)))
        (rename-buffer name) t))))
(advice-add 'org-tree-to-indirect-buffer :after 'my/org-rename-tree-to-indirect-buffer)

(defun ap/org-agenda-goto-heading-in-indirect-buffer (&optional switch-to)
  "Go to the current agenda headline in an indirect buffer. If SWITCH-TO is non-nil, close the org-agenda window."
  (interactive)
  (if switch-to
      (org-agenda-switch-to)
    (org-agenda-goto))
  (org-tree-to-indirect-buffer)

  ;; Put the non-indirect buffer at the bottom of the prev-buffers
  ;; list so it won't be selected when the indirect buffer is killed
  (set-window-prev-buffers nil (append (cdr (window-prev-buffers))
                                       (car (window-prev-buffers)))))

(defun ap/org-agenda-switch-to-heading-in-indirect-buffer ()
  (interactive)
  (ap/org-agenda-goto-heading-in-indirect-buffer t))

(defun zin/org-tag-match-context (&optional todo-only match)
  "Identical search to `org-match-sparse-tree', but shows the content of the matches."
  (interactive "P")
  (org-prepare-agenda-buffers (list (current-buffer)))
  (org-overview)
  (org-remove-occur-highlights)
  (org-scan-tags '(progn (org-show-entry)
                         (org-show-context))
                 (cdr (org-make-tags-matcher match)) todo-only))

(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(defun org-back-to-item ()
  (re-search-backward "^ *[-+*]\\|^ *[1-9]+[)\.] " nil nil 1))

(defun org-fill-paragraph-handle-lists (&optional num-paragraphs)
  (interactive "p")
  (save-excursion
    (let ((bound (if mark-active
                     (- (region-end) 2)
                   (progn
                     (org-back-to-item)
                     (while (>= num-paragraphs 0)
                       (call-interactively 'org-mark-element)
                       (setq num-paragraphs (1- num-paragraphs)))
                     (- (region-end) 2)))))
      (while (search-forward "\n" bound t)
        (replace-match " ")))
    (org-fill-paragraph)))

;; (define-key spacemacs-org-mode-map (kbd "C-M-q") 'org-fill-paragraph-handle-lists)
(defun org-random-entry (&optional arg)
  "Select and goto a random todo item from the global agenda"
  (interactive "P")
  (if org-agenda-overriding-arguments
      (setq arg org-agenda-overriding-arguments))
  (if (and (stringp arg) (not (string-match "\\S-" arg))) (setq arg nil))
  (let* ((today (org-today))
         (date (calendar-gregorian-from-absolute today))
         (kwds org-todo-keywords-for-agenda)
         (lucky-entry nil)
         (completion-ignore-case t)
         (org-agenda-buffer (when (buffer-live-p org-agenda-buffer)
                              org-agenda-buffer))
         (org-select-this-todo-keyword
          (if (stringp arg) arg
            (and arg (integerp arg) (> arg 0)
                 (nth (1- arg) kwds))))
         rtn rtnall files file pos marker buffer)
    (when (equal arg '(4))
      (setq org-select-this-todo-keyword
            (org-icompleting-read "Keyword (or KWD1|K2D2|...): "
                                  (mapcar 'list kwds) nil nil)))
    (and (equal 0 arg) (setq org-select-this-todo-keyword nil))
    (catch 'exit
      (org-compile-prefix-format 'todo)
      (org-set-sorting-strategy 'todo)
      (setq files (org-agenda-files nil 'ifmode)
            rtnall nil)
      (while (setq file (pop files))
        (catch 'nextfile
          (org-check-agenda-file file)
          (setq rtn (org-agenda-get-day-entries file date :todo))
          (setq rtnall (append rtnall rtn))))

      (when rtnall
        (setq lucky-entry
              (nth (random
                    (safe-length
                     (setq entries rtnall)))
                   entries))

        (setq marker (or (get-text-property 0 'org-marker lucky-entry)
                         (org-agenda-error)))
        (setq buffer (marker-buffer marker))
        (setq pos (marker-position marker))
        (org-pop-to-buffer-same-window buffer)
        (widen)
        (goto-char pos)
        (when (derived-mode-p 'org-mode)
          (org-show-context 'agenda)
          (save-excursion
            (and (outline-next-heading)
                 (org-flag-heading nil))) ; show the next heading
          (when (outline-invisible-p)
            (show-entry))                 ; display invisible text
          (run-hooks 'org-agenda-after-show-hook))))))

(defun my/org-link-projects (location)
  "Add link properties between the current subtree and the one specified by LOCATION."
  (interactive
   (list (let ((org-refile-use-cache nil))
           (org-refile-get-location "Location"))))
  (let ((link1 (org-store-link nil)) link2)
    (save-window-excursion
      (org-refile 4 nil location)
      (setq link2 (org-store-link nil))
      (org-set-property "LINK" link1))
    (org-set-property "LINK" link2)))

(defun my/org-insert-heading-for-next-day ()
  "Insert a same-level heading for the following day."
  (interactive)
  (let ((new-date
         (seconds-to-time
          (+ 86400.0
             (float-time
              (org-read-date nil 'to-time (elt (org-heading-components) 4)))))))
    (org-insert-heading-after-current)
    (insert (format-time-string "%Y-%m-%d\n\n" new-date))))

(defun org-back-to-top-level-heading ()
  "Go back to the current top level heading."
  (interactive)
  (or (re-search-backward "^\* " nil t)
      (goto-char (point-min))))

(defun org-show-next-heading-tidily ()
  (interactive)
  "Show next entry, keeping other entries closed."
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(defun org-show-previous-heading-tidily ()
  (interactive)
  "Show previous entry, keeping other entries closed."
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-on-heading-p))
      (goto-char pos)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(defun org-show-current-heading-tidily ()
  (interactive)  ;Inteactive
  "Show next entry, keeping other entries closed."
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-back-to-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))


(defun org-auto-tag () (interactive) (let ((alltags (append org-tag-persistent-alist org-tag-alist)) (headline-words (split-string (org-get-heading t t))) ) (mapcar (lambda (word) (if (assoc word alltags) (org-toggle-tag word 'on))) headline-words)) )



;; (add-to-list 'org-speed-commands-user
;;              '("n" ded/org-show-next-heading-tidily))
;; (add-to-list 'org-speed-commands-user
;;              '("p" ded/org-show-previous-heading-tidily))

(defun dmj:turn-headline-into-org-mode-link ()
  "Replace word at point by an Org mode link."
  (interactive)
  (when (org-at-heading-p)
    (let ((hl-text (nth 4 (org-heading-components))))
      (unless (or (null hl-text)
                  (org-string-match-p "^[ \t]*:[^:]+:$" hl-text))
        (beginning-of-line)
        (search-forward hl-text (point-at-eol))
        (replace-string
         hl-text
         (format "[[file:%s.org][%s]]"
                 (org-link-escape hl-text)
                 (org-link-escape hl-text '((?\] . "%5D") (?\[ . "%5B"))))
         nil (- (point) (length hl-text)) (point))))))

(defun org-check-misformatted-subtree ()
  "Check misformatted entries in the current buffer."
  (interactive)
  (show-all)
  (org-map-entries
   (lambda ()
     (when (and (move-beginning-of-line 2)
                (not (looking-at org-heading-regexp)))
       (if (or (and (org-get-scheduled-time (point))
                    (not (looking-at (concat "^.*" org-scheduled-regexp))))
               (and (org-get-deadline-time (point))
                    (not (looking-at (concat "^.*" org-deadline-regexp)))))
           (when (y-or-n-p "Fix this subtree? ")
             (message "Call the function again when you're done fixing this subtree.")
             (recursive-edit))
         (message "All subtrees checked."))))))

(defun my-org-extract-link ()
  "Extract the link location at point and put it on the killring."
  (interactive)
  (when (org-in-regexp org-bracket-link-regexp 1)
    (kill-new (org-link-unescape (org-match-string-no-properties 1)))))

(defun mrb/insert-created-timestamp()
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (org-expiry-insert-created)
  (org-back-to-heading)
  (org-end-of-line)
  (insert " ")
  )
;; Whenever a TODO entry is created, I want a timestamp
;; Advice org-insert-todo-heading to insert a created timestamp using org-expiry
;; (defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
;;   "Insert a CREATED property using org-expiry.el for TODO entries"
;;   (mrb/insert-created-timestamp)
;;   )
;; ;; Make it active
;; (ad-activate 'org-insert-todo-heading)
;; (defadvice org-capture (after mrb/created-timestamp-advice activate)
;;   "Insert a CREATED property using org-expiry.el for TODO entries"
;;                                         ; Test if the captured entry is a TODO, if so insert the created
;;                                         ; timestamp property, otherwise ignore
;;   (when (member (org-get-todo-state) org-todo-keywords-1)
;;     (mrb/insert-created-timestamp)))
;; (ad-activate 'org-capture)

(defun with-no-drawer (func &rest args)
  (interactive "P")
  (let ((org-log-into-drawer (not (car args))))
    (funcall func)))

(advice-add 'org-add-note :around #'with-no-drawer)

;; define "R" as the prefix key for reviewing what happened in various
;; time periods
;;(add-to-list 'org-agenda-custom-commands
;;             '("R" . "Review" )
;;             )

;; Show the agenda with the log turn on, the clock table show and
;; archived entries shown.  These commands are all the same exept for
;; the time period.
;; (add-to-list 'org-agenda-custom-commands
;;              `("Rw" "Week in review"
;;                 agenda ""
;;                 ;; agenda settings
;;                 ,(append
;;                   efs/org-agenda-review-settings
;;                   '((org-agenda-span 'week)
;;                     (org-agenda-start-on-weekday 0)
;;                     (org-agenda-overriding-header "Week in Review"))
;;                   )
;;                 ("~/Dropbox/org/review/week.html")
;;                 ))


;; (add-to-list 'org-agenda-custom-commands
;;              `("Rd" "Day in review"
;;                 agenda ""
;;                 ;; agenda settings
;;                 ,(append
;;                   efs/org-agenda-review-settings
;;                   '((org-agenda-span 'day)
;;                     (org-agenda-overriding-header "Week in Review"))
;;                   )
;;                 ("~/Dropbox/org/review/day.html")
;;                 ))

;; (add-to-list 'org-agenda-custom-commands
;;              `("Rm" "Month in review"
;;                 agenda ""
;;                 ;; agenda settings
;;                 ,(append
;;                   efs/org-agenda-review-settings
;;                   '((org-agenda-span 'month)
;;                     (org-agenda-start-day "01")
;;                     (org-read-date-prefer-future nil)
;;                     (org-agenda-overriding-header "Month in Review"))
;;                   )
;;                 ("~/Dropbox/org/review/month.html")
;;                 ))
;; ;; Add feature to allow easy adding of tags in a capture window
;; (defun mrb/add-tags-in-capture()
;;   (interactive)
;;   "Insert tags in a capture window without losing the point"
;;   (save-excursion
;;     (org-back-to-heading)
;;     (org-set-tags)))
;; ;; Bind this to a reasonable key
;; (define-key org-capture-mode-map "\C-c\C-t" 'mrb/add-tags-in-capture)

(defun my-org-insert-link ()
  "Insert org link where default description is set to html title."
  (interactive)
  (let* ((url (read-string "URL: "))
         (title (get-html-title-from-url url)))
    (org-insert-link nil url title)))

(defun get-html-title-from-url (url)
  "Return content in <title> tag."
  (let (x1 x2 (download-buffer (url-retrieve-synchronously url)))
    (save-excursion
      (set-buffer download-buffer)
      (beginning-of-buffer)
      (setq x1 (search-forward "<title>"))
      (search-forward "</title>")
      (setq x2 (search-backward "<"))
      (mm-url-decode-entities-string (buffer-substring-no-properties x1 x2)))))

(defun dmj/org-remove-redundant-tags ()
  "Remove redundant tags of headlines in current buffer.

A tag is considered redundant if it is local to a headline and
inherited by a parent headline."
  (interactive)
  (when (eq major-mode 'org-mode)
    (save-excursion
      (org-map-entries
       (lambda ()
         (let ((alltags (split-string (or (org-entry-get (point) "ALLTAGS") "") ":"))
               local inherited tag)
           (dolist (tag alltags)
             (if (get-text-property 0 'inherited tag)
                 (push tag inherited) (push tag local)))
           (dolist (tag local)
             (if (member tag inherited) (org-toggle-tag tag 'off)))))
       t nil))))

(defun dmj/org-remove-empty-propert-drawers ()
  "*Remove all empty property drawers in current file."
  (interactive)
  (unless (eq major-mode 'org-mode)
    (error "You need to turn on Org mode for this function."))
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward ":PROPERTIES:" nil t)
      (save-excursion
        (org-remove-empty-drawer-at "PROPERTIES" (match-beginning 0))))))

(defun org-agenda-reschedule-to-today ()
  (interactive)
  (cl-flet ((org-read-date (&rest rest) (current-time)))
    (call-interactively 'org-agenda-schedule)))


;; (defun org-age-set-to-today-if-missing ()
;;   (interactive)
;;   (or (org-entry-get (point) org-age-property)
;;       (let ((d (format-time-string "%Y-%m-%d" (current-time))))
;;         (org-entry-put (point) org-age-property d)
;;         d)))
;; (defun org-age-set-all (setf)
;;   (let ((rs (org-map-entries setf org-age-todo-match 'agenda)))
;;     rs))

;; (defun org-age-set-all-to-today ()
;;   (interactive)
;;   (org-age-set-all 'org-age-set-to-today-if-missing))
;; (org-age-set-all-to-today)
;; (defun org-age-compare (a b)
;;   (let* ((ma (get-text-property 1 'org-marker a))
;;          (mb (get-text-property 1 'org-marker b))
;;          (da (with-current-buffer (marker-buffer ma)
;;                (goto-char (marker-position ma))
;;                (org-age-set-to-today-if-missing)))
;;          (db (with-current-buffer (marker-buffer mb)
;;                (goto-char (marker-position mb))
;;                (org-age-set-to-today-if-missing))))
;;     (cond
;;      ((string< da db) -1)
;;      ((string= da db) nil)
;;      (t +1))))
(defun my-org-un-project ()
  (interactive)
  (org-map-entries 'org-do-promote "LEVEL>1" 'tree)
  (org-cycle t))
(require 'cl)

(defun org-point-at-end-of-empty-headline ()
  "If point is at the end of an empty headline, return t, else nil."
  (and (looking-at "[ \t]*$")
       (save-excursion
         (beginning-of-line 1)
         (looking-at (concat "^\\(\\*+\\)[ \t]+\\(" org-todo-regexp "\\)?[ \t]*")))))

(defun org-level-increment ()
  "Return the number of stars that will be added or removed at a
time to headlines when structure editing, based on the value of
`org-odd-levels-only'."
  (if org-odd-levels-only 2 1))

(defvar org-previous-line-level-cached nil)

(defun org-recalculate-previous-line-level ()
  "Same as `org-get-previous-line-level', but does not use cached
value. It does *set* the cached value, though."
  (set 'org-previous-line-level-cached
       (let ((current-level (org-current-level))
             (prev-level (when (> (line-number-at-pos) 1)
                           (save-excursion
                             (previous-line)
                             (org-current-level)))))
         (cond ((null current-level) nil) ; Before first headline
               ((null prev-level) 0)      ; At first headline
               (prev-level)))))

(defun org-get-previous-line-level ()
  "Return the outline depth of the last headline before the
current line. Returns 0 for the first headline in the buffer, and
nil if before the first headline."
  ;; This calculation is quite expensive, with all the regex searching
  ;; and stuff. Since org-cycle-level won't change lines, we can reuse
  ;; the last value of this command.
  (or (and (eq last-command 'org-cycle-level)
           org-previous-line-level-cached)
      (org-recalculate-previous-line-level)))

(defun org-cycle-level ()
  (interactive)
  (let ((org-adapt-indentation nil))
    (when (org-point-at-end-of-empty-headline)
      (setq this-command 'org-cycle-level) ;Only needed for caching
      (let ((cur-level (org-current-level))
            (prev-level (org-get-previous-line-level)))
        (cond
         ;; If first headline in file, promote to top-level.
         ((= prev-level 0)
          (loop repeat (/ (- cur-level 1) (org-level-increment))
                do (org-do-promote)))
         ;; If same level as prev, demote one.
         ((= prev-level cur-level)
          (org-do-demote))
         ;; If parent is top-level, promote to top level if not already.
         ((= prev-level 1)
          (loop repeat (/ (- cur-level 1) (org-level-increment))
                do (org-do-promote)))
         ;; If top-level, return to prev-level.
         ((= cur-level 1)
          (loop repeat (/ (- prev-level 1) (org-level-increment))
                do (org-do-demote)))
         ;; If less than prev-level, promote one.
         ((< cur-level prev-level)
          (org-do-promote))
         ;; If deeper than prev-level, promote until higher than
         ;; prev-level.
         ((> cur-level prev-level)
          (loop repeat (+ 1 (/ (- cur-level prev-level) (org-level-increment)))
                do (org-do-promote))))
        t))))

(defun org-agenda-reschedule-to-today ()
  (interactive)
  (cl-flet ((org-read-date (&rest rest) (current-time)))
    (call-interactively 'org-agenda-schedule)))

(defun jd-org-current-time ()
  "foo"
  (interactive)
  (insert (format-time-string "[%H:%M]"))
  )


(defun jd-org-today ()
  "insert a new heading with today's date"
  (interactive)
  (smart-org-meta-return-dwim)
  (org-insert-time-stamp (current-time))
  )


(defun jd-org-today-and-accountability ()
  "insert a new heading with today's date"
  (interactive)
  (insert "\n** committed actions: ")
  (org-insert-time-stamp (current-time))
  (insert " [0%]\n")
  (insert "*** TODO meditate\n")
  (insert "*** TODO morning pages\n")
  (insert "*** TODO write 500 words\n")
  (insert "*** TODO \n")
  (left-char)
  )

(defun jd-clock-in ()
  "insert a new heading with today's date, and then clock in"
  (interactive)
  (org-insert-heading ())
  (org-insert-time-stamp (current-time))
  (org-clock-in)
  (next-line)
  (next-line)
  )

;; (defun org-word-count (beg end
;;                            &optional count-latex-macro-args?
;;                            count-footnotes?)
;;   "Report the number of words in the Org mode buffer or selected region.
;; Ignores:
;; - comments
;; - tables
;; - source code blocks (#+BEGIN_SRC ... #+END_SRC, and inline blocks)
;; - hyperlinks (but does count words in hyperlink descriptions)
;; - tags, priorities, and TODO keywords in headers
;; - sections tagged as 'not for export'.

;; The text of footnote definitions is ignored, unless the optional argument
;; COUNT-FOOTNOTES? is non-nil.

;; If the optional argument COUNT-LATEX-MACRO-ARGS? is non-nil, the word count
;; includes LaTeX macro arguments (the material between {curly braces}).
;; Otherwise, and by default, every LaTeX macro counts as 1 word regardless
;; of its arguments."
;;   (interactive "r")
;;   (unless mark-active
;;     (setf beg (point-min)
;;           end (point-max)))
;;   (let ((wc 0)
;;         (latex-macro-regexp "\\\\[A-Za-z]+\\(\\[[^]]*\\]\\|\\){\\([^}]*\\)}"))
;;     (save-excursion
;;       (goto-char beg)
;;       (while (< (point) end)
;;         (cond
;;          ;; Ignore comments.
;;          ((or (org-at-comment-p) (org-at-table-p))
;;           nil)
;;          ;; Ignore hyperlinks. But if link has a description, count
;;          ;; the words within the description.
;;          ((looking-at org-bracket-link-analytic-regexp)
;;           (when (match-string-no-properties 5)
;;             (let ((desc (match-string-no-properties 5)))
;;               (save-match-data
;;                 (incf wc (length (remove "" (org-split-string
;;                                              desc "\\W")))))))
;;           (goto-char (match-end 0)))
;;          ((looking-at org-any-link-re)
;;           (goto-char (match-end 0)))
;;          ;; Ignore source code blocks.
;;          ((org-between-regexps-p "^#\\+BEGIN_SRC\\W" "^#\\+END_SRC\\W")
;;           nil)
;;          ;; Ignore inline source blocks, counting them as 1 word.
;;          ((save-excursion
;;             (backward-char)
;;             (looking-at org-babel-inline-src-block-regexp))
;;           (goto-char (match-end 0))
;;           (setf wc (+ 2 wc)))
;;          ;; Count latex macros as 1 word, ignoring their arguments.
;;          ((save-excursion
;;             (backward-char)
;;             (looking-at latex-macro-regexp))
;;           (goto-char (if count-latex-macro-args?
;;                          (match-beginning 2)
;;                        (match-end 0)))
;;           (setf wc (+ 2 wc)))
;;          ;; Ignore footnotes.
;;          ((and (not count-footnotes?)
;;                (or (org-footnote-at-definition-p)
;;                    (org-footnote-at-reference-p)))
;;           nil)
;;          (t
;;           (let ((contexts (org-context)))
;;             (cond
;;              ;; Ignore tags and TODO keywords, etc.
;;              ((or (assoc :todo-keyword contexts)
;;                   (assoc :priority contexts)
;;                   (assoc :keyword contexts)
;;                   (assoc :checkbox contexts))
;;               nil)
;;              ;; Ignore sections marked with tags that are
;;              ;; excluded from export.
;;              ((assoc :tags contexts)
;;               (if (intersection (org-get-tags-at) org-export-exclude-tags
;;                                 :test 'equal)
;;                   (org-forward-same-level 1)
;;                 nil))
;;              (t
;;               (incf wc))))))
;;         (re-search-forward "\\w+\\W*")))
;;     (message (format "%d words in %s." wc
;;                      (if mark-active "region" "buffer")))))

;;; org-jump.el --- navigate over the structure of an org file
;;
;; Author: Christoph Lange <math.semantic.web@gmail.com>
;;
;; Copyright (C) 2016 by Christoph Lange 
;;
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(defun org-jump-to-child ()
  "Interactively prompts for the title of a child node of the current heading and jumps to the last child node having that title.  This function will not work if the first child node is not exactly one level below the current heading."
  (interactive)
  (let* ((child-position
          (save-excursion
            ;; Go to the heading of the current node
            (org-back-to-heading)
            (let* ((ref-level (org-reduced-level (org-outline-level))))
              (outline-next-heading)
              ;; If the next visible heading is one level lower, then ...
              (if (= (- (org-reduced-level (org-outline-level)) ref-level) 1)
                  (let* ((children nil)
                         (continue t))
                    (while continue
                      (let* ((old-point (point)))
                        ;; ... continue adding its headline text and the point to a list
                        (add-to-list 'children
                                     (cons
                                      ;; remove any markup such as links (copied from org-clock-in)
                                      (replace-regexp-in-string
                                       "\\[\\[.*?\\]\\[\\(.*?\\)\\]\\]" "\\1"
                                       (substring-no-properties (nth 4 (org-heading-components))))
                                      old-point))
                        ;; ... and go to the next sibling.
                        (org-forward-heading-same-level 1 t)
                        (setq continue (/= (point) old-point))))
                    ;; Prompt for a child headline text, ...
                    (let* ((child (org-icompleting-read "Headline text: " (mapcar 'car children))))
                      ;; ... and return its location (point).
                      (cdr (assoc child children))))
                ;; Otherwise return -1.
                -1)))))
    ;; Go to the desired heading and make it visible, or otherwise output an error message.
    (if (> child-position -1)
        (progn
          (goto-char child-position)
          (org-show-context))
      (message "No children."))))

;; (define-key org-mode-map (kbd "\C-coc") 'org-jump-to-child)

(defun org-jump-to-id ()
  "Interactively prompts for an identifier and searches for the first node in the current file that has this identifier as a CUSTOM_ID property."
  (interactive)
  (let* ((property "CUSTOM_ID")
         (custom-id (org-icompleting-read "CUSTOM_ID of entry: "
                                          (mapcar 'list (org-property-values property)))))
    ;; What will happen if there is more than one node with this CUSTOM_ID?
    ;; Alternative implementation:
    ;; (org-jump-to-first-node-with-property-value property custom-id)
    (org-link-search (concat "#" custom-id))))

;; (define-key org-mode-map (kbd "\C-coj") 'org-jump-to-id)

(defun org-jump-to-first-node-with-property-value (property value)
  (interactive)
  (goto-char
   (car
    (org-scan-tags 'point 
                   (cdr
                    (org-make-tags-matcher (format "%s=\"%s\"" property value))))))
  (org-show-context))

;; further idea: org-find-text-property-in-string
