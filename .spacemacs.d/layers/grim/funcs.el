(defun ora-cap-filesystem ()
  (let (path)
    (when (setq path (ffap-string-at-point))
      (let ((compl (all-completions path #'read-file-name-internal)))
        (when compl
          (let ((offset (ivy-completion-common-length (car compl))))
            (list (- (point) offset) (point) compl)))))))

;; https://unix.stackexchange.com/questions/19124/bash-multi-line-command-with-comments-after-the-continuation-character
(defun shell-multiline-comment ()
  (interactive)
  (back-to-indentation)
  (insert "`" comment-start)
  (search-forward "\\")
  (backward-char 2)
  (insert "`"))
(defun shell-multiline-uncomment ()
  (interactive)
  (back-to-indentation)
  (search-forward "\`")
  (backward-char)
  (delete-char 2)
  (search-forward "\`")
  (backward-char)
  (delete-char 1)
  (indent-according-to-mode)
  )

(defun buffer-local-set-key (key func)
  (interactive "KSet key on this buffer: \naCommand: ")
  (let ((name (format "%s-magic" (buffer-name))))
    (eval
     `(define-minor-mode ,(intern name)
        "Automagically built minor mode to define buffer-local keys."))
    (let* ((mapname (format "%s-map" name))
           (map (intern mapname)))
      (unless (boundp (intern mapname))
        (set map (make-sparse-keymap)))
      (eval
       `(define-key ,map ,key func)))
    (funcall (intern name) t)))

(defun fill-buffer ()
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (fill-region (point-min) (point-max)))))

(defun my-adjoin-to-list-or-symbol (element list-or-symbol)
  (let ((list (if (not (listp list-or-symbol))
                  (list list-or-symbol)
                list-or-symbol)))
    (require 'cl-lib)
    (cl-adjoin element list)))

;; (eval-after-load "org"
;;   '(mapc
;;     (lambda (face)
;;       (set-face-attribute
;;        face nil
;;        :inherit
;;        (my-adjoin-to-list-or-symbol
;;         'fixed-pitch
;;         (face-attribute face :inherit))))
;;     (list 'org-code 'org-block 'org-table 'org-block-background)))

(defun ejmr-helpful-try-all (term)
  "Searches for help on TERM using all Helpful commands.

Specifically, this function tries using `helpful-command',
`helpful-macro', and `helpful-function', in that order.  If none
of them find anything then this function signals the error
`wrong-type-argument' error, just like the Helpful functions do
when they receive an argument they do not recognize."
  (interactive "sQuery Term: ")
  (let ((term (if (symbolp term) term (intern term)))
        (helpful-fns (list #'helpful-command
                           #'helpful-macro
                           #'helpful-function)))
    (dolist (current-fn helpful-fns)
      (condition-case nil
          (funcall current-fn term)
        (wrong-type-argument nil)))))

;; If a region is selected, delete all blank lines in that region.
;; Else, call `delete-blank-lines'.
(defun modi/delete-blank-lines-in-region (&rest args)
  (let ((do-not-run-orig-fn (use-region-p)))
    (when do-not-run-orig-fn
      (flush-lines "^[[:blank:]]*$" (region-beginning) (region-end)))
    do-not-run-orig-fn))
(advice-add 'delete-blank-lines :before-until #'modi/delete-blank-lines-in-region)

(defun duplicate-thing (comment)
  "Duplicates the current line, or the region if active. If an argument is
given, the duplicated region will be commented out."
  (interactive "P")
  (save-excursion
    (let ((start (if (region-active-p) (region-beginning) (point-at-bol)))
          (end   (if (region-active-p) (region-end) (point-at-eol))))
      (goto-char end)
      (unless (region-active-p) (newline))
      (insert (buffer-substring start end))
      (when comment (comment-region start end)))))

(defun revert-buffer-no-confirm ()
  "Revert(Reload/Refresh) buffer without confirmation."
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))

(defun my-org-archive-done-tasks ()
  "Move all done tasks in the current buffer to archive file."
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))

(defun insert-date (prefix)
  "Insert the current date with as PREFIX."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%d-%m-%Y")
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "de_DE"))
    (insert (format-time-string format))))

(defun ap/sort-lines (start end)
  "Sort lines the region touches.

Contrary to its docstring, `sort-lines' only works on characters
inside the region. So if only part of a line is in the region,
only that part of the line is sorted. Characters outside of the
region are not sorted, which is not very useful: the most
commonly desired action is to sort entire lines, not to sort only
parts of lines. To work around that, the user must make sure to
select entire lines, which requires extra keystrokes. In
contrast, this function sorts only entire lines, and sorts all
lines that the region touches. This is much more useful."
  (interactive "r")
  (let* ((start (save-excursion
                  (goto-char start)
                  (line-beginning-position)))
         (end (save-excursion
                (goto-char end)
                (line-end-position))))
    (sort-lines nil start end)))

(defun ap/sort-words-in-region (start end)
  "Sort words in the region.

Note that this collapses newlines into spaces, so it's not
suitable for sorting words across hard line breaks."
  (interactive "r")
  (let* ((sorted-words (sort (split-string (buffer-substring-no-properties start end))
                             'string<))
         (string (s-join " " sorted-words)))
    (delete-region start end)
    (insert string)))

(defun toggle-letter-case ()
   "Toggle the letter case of current word or text selection.
   Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
   (interactive)
   (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )
    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps") )
         (t (put this-command 'state "all lower") ) ) ) )
    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )
    ))

(fset 'grim/js-delete-surrounding-function
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("%x``df(" 0 "%d")) arg)))

(defun k20e/cycle-spacing (&optional n)
  "Make `cycle-spacing' operate in `fast' mode."
  (interactive "*p")
  (cycle-spacing n nil 'fast))

;; WORKAROUND https://github.com/magit/magit/issues/2395
(define-derived-mode magit-staging-mode magit-status-mode "Magit staging"
  "Mode for showing staged and unstaged changes."
  :group 'magit-status)
(defun magit-staging-refresh-buffer ()
  (magit-insert-section (status)
    (magit-insert-untracked-files)
    (magit-insert-unstaged-changes)
    (magit-insert-staged-changes)))
(defun magit-staging ()
  (interactive)
  (magit-mode-setup #'magit-staging-mode))

;; version of ivy-yank-word to yank from start of word
(defun bjm/ivy-yank-whole-word ()
  "Pull next word from buffer into search string."
  (interactive)
  (let (amend)
    (with-ivy-window
      ;;move to Last Word boundary
      (re-search-backward "\\b")
      (let ((pt (point))
            (le (line-end-position)))
        (forward-word 1)
        (if (> (point) le)
            (goto-char pt)
          (setq amend (buffer-substring-no-properties pt (point))))))
    (when amend
      (insert (replace-regexp-in-string "  +" " " amend)))))

(defun sk/goto-closest-number ()
  (interactive)
  (let ((closest-behind (save-excursion (search-backward-regexp "[0-9]" nil t)))
        (closest-ahead (save-excursion (search-forward-regexp "[0-9]" nil t))))
    (push-mark)
    (goto-char
     (cond
      ((and (not closest-ahead) (not closest-behind)) (error "No numbers in buffer"))
      ((and closest-ahead (not closest-behind)) closest-ahead)
      ((and closest-behind (not closest-ahead)) closest-behind)
      ((> (- closest-ahead (point)) (- (point) closest-behind)) closest-behind)
      ((> (- (point) closest-behind) (- closest-ahead (point))) closest-ahead)
      :else closest-ahead))))

(defun smart-self-insert-punctuation (count)
  "If COUNT=1 and the point is after a space, insert the relevant
character before any spaces."
  (interactive "p")
  (if (and (= count 1)
           (eq (char-before) ?\s))
      (save-excursion
        (skip-chars-backward " ")
        (self-insert-command 1))
    (self-insert-command count)))

(defun narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or
defun, whichever applies first. Narrowing to
org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer
is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))

;; (define-key endless/toggle-map "n"
;;   #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing
;; keymap, that's how much I like this command. Only
;; copy it if that's what you want.
;; (define-key ctl-x-map "n" #'narrow-or-widen-dwim)
;; (add-hook 'LaTeX-mode-hook
;;           (lambda ()
;;             (define-key LaTeX-mode-map "\C-xn"
;;               nil)))

(defun grim/my-copy-simple (&optional beg end)
  "Save the current region (or line) to the `kill-ring' after stripping extra whitespace and new lines"
  (interactive
   (if (region-active-p)
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-end-position))))
  (let ((my-text (buffer-substring-no-properties beg end)))
    (with-temp-buffer 
      (insert my-text)
      (goto-char 1)
      (while (looking-at "[ \t\n]")
        (delete-char 1))
      (let ((fill-column 9333999))
        (fill-region (point-min) (point-max)))
      (kill-region (point-min) (point-max)))))

(defun endless/config-prose-completion ()
  "Make auto-complete less agressive in this buffer."
  (setq-local company-minimum-prefix-length 6)
  (setq-local ac-auto-start 6))

(defun endless/fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'endless/fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(defun grim/newline-above-below ()
  (interactive)
  (evil-escape)
  (evil-open-above 0)
  (evil-escape)
  (evil-next-line)
  (evil-open-below 0)
  (evil-escape))

(defun grim/paste-newline-above ()
  (interactive)
  (evil-escape)
  (evil-open-above 0)
  (evil-escape)
  (call-interactively 'clipboard-yank)
  (evil-escape)
  )

(defun grim/paste-newline-below ()
  (interactive)
  (evil-escape)
  (evil-open-below 0)
  (evil-escape)
  (call-interactively 'evil-paste-after)
  (evil-escape)
  )

(defun grim/nuke-all-buffers ()
  "Kill all buffers, leaving *scratch* only."
  (interactive)
  (mapcar (lambda (x) (kill-buffer x)) (buffer-list))
  (delete-other-windows))

(defun grim/file-reopen-as-root ()
  (interactive)
  (when buffer-file-name
    (find-alternate-file
     (concat "/sudo:root@localhost:"
             buffer-file-name))))

(defun grim/move-region-to-other-window (start end)
  "Move selected text to other window"
  (interactive "r")
  (if (use-region-p)
      (let ((count (count-words-region start end)))
        (save-excursion
          (kill-region start end)
          (other-window 1)
          (yank)
          (newline))
        (other-window -1)
        (message "Moved %s words" count))
    (message "No region selected")))

(defun grim/toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun grim/calc-eval-region (arg)
  "Evaluate an expression in calc and communicate the result.

If the region is active evaluate that, otherwise search backwards
to the first whitespace character to find the beginning of the
expression. By default, replace the expression with its value. If
called with the universal prefix argument, keep the expression
and insert the result into the buffer after it. If called with a
negative prefix argument, just echo the result in the
minibuffer."
  (interactive "p")
  (let (start end)
    (if (use-region-p)
        (setq start (region-beginning) end (region-end))
      (progn
        (setq end (point))
        (setq start (search-backward-regexp "\\s-\\|\n" 0 1))
        (setq start (1+ (if start start 0)))
        (goto-char end)))
    (let ((value (calc-eval (buffer-substring-no-properties start end))))
      (pcase arg
        (1 (delete-region start end))
        (4 (insert " = ")))
      (pcase arg
        ((or 1 4) (insert value))
        (-1 (message value))))))

(defun grim/narrow-to-region-indirect (start end &optional prefix)
  "Restrict editing in this buffer to the current region, indirectly.
 To deactivate indirect region when you're done, just kill the buffer.
 The new buffer is named as [wide-buffer-name].
 If non-nil, optional argument `prefix' is put ahead of indirect
buffer's name.
 If invoked with C-u, prompt user for `prefix' value."
  (interactive
   (cond
    ((eq current-prefix-arg nil)             ;; normal invocation
     (list (region-beginning) (region-end)))
    (t                                       ;; universal argument invocation
     (let ((prefix-readed (read-string "Prefix: ")))
       (list (region-beginning) (region-end) prefix-readed)))))
  (deactivate-mark)
  (let ((indirect-buffer-name (format "%s[%s]"
                                      (or prefix "") (buffer-name)))
        (buf (clone-indirect-buffer nil nil)))
    (with-current-buffer buf
      (narrow-to-region start end)
      (rename-buffer indirect-buffer-name t))
    (switch-to-buffer buf)))

(defun grim/replace-smart-quotes (beg end)
  "Replace 'smart quotes' in buffer or region with ascii quotes."
  (interactive "r")
  (format-replace-strings '(("\x201C" . "\"")
                            ("\x201D" . "\"")
                            ("\x2018" . "'")
                            ("\x2019" . "'"))
                          nil beg end))

;; Use variable width font faces in current buffer
(defun grim/buffer-face-mode-variable ()
  "Set font to a variable width (proportional) fonts in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "iaWriter Duospace" ))
  (buffer-face-mode))

;; Use monospaced font faces in current buffer
(defun grim/buffer-face-mode-fixed ()
  "Sets a fixed width (monospace) font in current buffer"
  (interactive)
  (setq buffer-face-mode-face '(:family "Fira Code"))
  (buffer-face-mode))
;; (defun my-adjoin-to-list-or-symbol (element list-or-symbol)
;;   (let ((list (if (not (listp list-or-symbol))
;;                   (list list-or-symbol)
;;                 list-or-symbol)))
;;     (require 'cl-lib)
;;     (cl-adjoin element list)))
