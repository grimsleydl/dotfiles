(defhydra hydra-undo-tree (:color yellow
                                  :hint nil
                                  )
  "
  _u_: undo  _r_: redo _s_: save _l_: load   "
  ("u"   undo-tree-undo)
  ("r"   undo-tree-redo)
  ("s"   undo-tree-save-history)
  ("l"   undo-tree-load-history)
  ("t"   undo-tree-visualize "visualize" :color blue)
  ("q"   nil "quit" :color blue))

(defhydra hydra-org-link-edit (:color red)
  "Org Link Edit"
  ("j" org-link-edit-forward-slurp "forward slurp")
  ("k" org-link-edit-forward-barf "forward barf")
  ("u" org-link-edit-backward-slurp "backward slurp")
  ("i" org-link-edit-backward-barf "backward barf")
  ("r" jk/unlinkify "remove link")
  ("q" nil "cancel" :color blue))

(defhydra soo-ivy (:hint nil :color pink)
  "
 Move     ^^^^^^^^^^ | Call         ^^^^ | Cancel^^ | Options^^ | Action _w_/_s_/_a_: %s(ivy-action-name)
----------^^^^^^^^^^-+--------------^^^^-+-------^^-+--------^^-+---------------------------------
 _g_ ^ ^ _k_ ^ ^ _u_ | _f_orward _o_ccur | _i_nsert | _c_alling: %-7s(if ivy-calling \"on\" \"off\") _C_ase-fold: %-10`ivy-case-fold-search
 ^↨^ _h_ ^+^ _l_ ^↕^ | _RET_ done     ^^ | _q_uit   | _m_atcher: %-7s(ivy--matcher-desc) _t_runcate: %-11`truncate-lines
 _G_ ^ ^ _j_ ^ ^ _d_ | _TAB_ alt-done ^^ | ^ ^      | _<_/_>_: shrink/grow
"
  ;; arrows
  ("j" ivy-next-line)
  ("k" ivy-previous-line)
  ("l" ivy-alt-done)
  ("h" ivy-backward-delete-char)
  ("g" ivy-beginning-of-buffer)
  ("G" ivy-end-of-buffer)
  ("d" ivy-scroll-up-command)
  ("u" ivy-scroll-down-command)
  ("e" ivy-scroll-down-command)
  ;; actions
  ("q" keyboard-escape-quit :exit t)
  ("C-g" keyboard-escape-quit :exit t)
  ("<escape>" keyboard-escape-quit :exit t)
  ("C-o" nil)
  ("i" nil)
  ("TAB" ivy-alt-done :exit nil)
  ("C-j" ivy-alt-done :exit nil)
  ;; ("d" ivy-done :exit t)
  ("RET" ivy-done :exit t)
  ("C-m" ivy-done :exit t)
  ("f" ivy-call)
  ("c" ivy-toggle-calling)
  ("m" ivy-toggle-fuzzy)
  (">" ivy-minibuffer-grow)
  ("<" ivy-minibuffer-shrink)
  ("w" ivy-prev-action)
  ("s" ivy-next-action)
  ("a" ivy-read-action)
  ("t" (setq truncate-lines (not truncate-lines)))
  ("C" ivy-toggle-case-fold)
  ("o" ivy-occur :exit t))

(defhydra hydra-help (:exit t)
    ;; Better to exit after any command because otherwise helm gets in a
    ;; mess, set hint to nil: written out manually.

    "
  Describe        ^^Keys                    ^^Search                    ^^Documentation
  ---------------------------------------------------------------------------------------
  _f_unction        _k_eybinding              _a_propros                  _i_nfo
  _p_ackage         _w_here-is                _d_oc strings               _n_: man
  _m_ode            _b_: show all bindings    _s_: info by symbol         _h_elm-dash
  _v_ariable

  "
    ;; Boring help commands...
    ("e" view-echo-area-messages "messages")
    ("l" view-lossage "lossage")
    ("C" describe-coding-system "coding-system")
    ("I" describe-input-method "input-method")


    ;; Documentation
    ("i" info nil)
    ("n" helm-man-woman nil)
    ("h" helm-dash)

    ;; Keybinds
    ("b" describe-bindings nil)
    ("c" describe-key-briefly nil)
    ("k" describe-key nil)
    ("w" where-is nil)

    ;; Search
    ("a" apropos-command nil)
    ("d" apropos-documentation nil)
    ("s" info-lookup-symbol nil)

    ;; Describe
    ("f" describe-function nil)
    ("p" describe-package nil)
    ("m" describe-mode nil)
    ("v" describe-variable nil)
    ("y" describe-syntax nil)

    ;; quit
    ("q" help-quit "quit"))

(defhydra hydra-buffer-menu (:color pink :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------                        (__)
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch                         (oo)
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch                      /------\\/
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur                 / |    ||
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only^^    *  /\\---/\\
_~_: modified      ^ ^                ^ ^                ^^                                 ~~   ~~
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))
(bind-key "." #'hydra-buffer-menu/body Buffer-menu-mode-map)


(defhydra hydra-yank-pop ()
   "Yank"
   ("C-y" yank nil)
   ("M-y" yank-pop nil)
   ("Y" (yank-pop -1) "previous")
   ("c" counsel-yank-pop "counsel")
   ;; ("l" (refine 'kill-ring) "list" :color blue)
   ("y" (yank-pop 1) "next")
   ("w" gist-region-or-buffer-private "private gist" :color blue)
   ("o" org-cliplink "org-cliplink" :color blue)
   ("q" nil "quit" :color blue))

(defhydra hydra-ibuffer-main (:color pink :hint nil)
  "
^Mark^         ^Actions^         ^View^          ^Select^              ^Navigation^
_m_: mark      _D_: delete       _g_: refresh    _q_: quit             _k_:   ↑    _h_
_u_: unmark    _s_: save marked  _S_: sort       _TAB_: toggle         _RET_: visit
_*_: specific  _a_: all actions  _/_: filter     _o_: other window     _j_:   ↓    _l_
_t_: toggle    _._: toggle hydra _H_: help       C-o other win no-select
"
  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)
  ("t" ibuffer-toggle-marks)

  ("D" ibuffer-do-delete)
  ("s" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("S" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)
  ("H" describe-mode :color blue)

  ("h" ibuffer-backward-filter-group)
  ("k" ibuffer-backward-line)
  ("l" ibuffer-forward-filter-group)
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)

  ("TAB" ibuffer-toggle-filter-group)

  ("o" ibuffer-visit-buffer-other-window :color blue)
  ("q" quit-window :color blue)
  ("." nil :color blue))
(defhydra hydra-ibuffer-mark (:color teal :columns 5
                              :after-exit (hydra-ibuffer-main/body))
  "Mark"
  ("*" ibuffer-unmark-all "unmark all")
  ("M" ibuffer-mark-by-mode "mode")
  ("m" ibuffer-mark-modified-buffers "modified")
  ("u" ibuffer-mark-unsaved-buffers "unsaved")
  ("s" ibuffer-mark-special-buffers "special")
  ("r" ibuffer-mark-read-only-buffers "read-only")
  ("/" ibuffer-mark-dired-buffers "dired")
  ("e" ibuffer-mark-dissociated-buffers "dissociated")
  ("h" ibuffer-mark-help-buffers "help")
  ("z" ibuffer-mark-compressed-file-buffers "compressed")
  ("b" hydra-ibuffer-main/body "back" :color blue)
  ("q" quit-window "quit" :color blue))
(defhydra hydra-ibuffer-action (:color teal :columns 4
                                :after-exit
                                (if (eq major-mode 'ibuffer-mode)
                                    (hydra-ibuffer-main/body)))
  "Action"
  ("A" ibuffer-do-view "view")
  ("E" ibuffer-do-eval "eval")
  ("F" ibuffer-do-shell-command-file "shell-command-file")
  ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
  ("H" ibuffer-do-view-other-frame "view-other-frame")
  ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
  ("M" ibuffer-do-toggle-modified "toggle-modified")
  ("O" ibuffer-do-occur "occur")
  ("P" ibuffer-do-print "print")
  ("Q" ibuffer-do-query-replace "query-replace")
  ("R" ibuffer-do-rename-uniquely "rename-uniquely")
  ("T" ibuffer-do-toggle-read-only "toggle-read-only")
  ("U" ibuffer-do-replace-regexp "replace-regexp")
  ("V" ibuffer-do-revert "revert")
  ("W" ibuffer-do-view-and-eval "view-and-eval")
  ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
  ("b" nil "back")
  ("q" quit-window "quit" :color blue))
(defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
  "Sort"
  ("i" ibuffer-invert-sorting "invert")
  ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
  ("v" ibuffer-do-sort-by-recency "recently used")
  ("s" ibuffer-do-sort-by-size "size")
  ("f" ibuffer-do-sort-by-filename/process "filename")
  ("m" ibuffer-do-sort-by-major-mode "mode")
  ("b" hydra-ibuffer-main/body "back" :color blue)
  ("q" quit-window "quit" :color blue))
(defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
  "Filter"
  ("m" ibuffer-filter-by-used-mode "mode")
  ("M" ibuffer-filter-by-derived-mode "derived mode")
  ("n" ibuffer-filter-by-name "name")
  ("c" ibuffer-filter-by-content "content")
  ("e" ibuffer-filter-by-predicate "predicate")
  ("f" ibuffer-filter-by-filename "filename")
  (">" ibuffer-filter-by-size-gt "size")
  ("<" ibuffer-filter-by-size-lt "size")
  ("/" ibuffer-filter-disable "disable")
  ("b" hydra-ibuffer-main/body "back" :color blue)
  ("q" quit-window "quit" :color blue))
(define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body)
(add-hook 'ibuffer-hook #'hydra-ibuffer-main/body)


(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(defhydra sk/hydra-org-organize (:color red
                                        :hint nil)
  "
 ^Meta^    ^Shift^   ^Shift-Meta^ ^Shift-Ctrl^  ^Move^        ^Item^
^^^^^^^^^^^^^--------------------------------------------------------------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^   ^ ^ _p_ ^ ^      ^ ^ _P_ ^ ^       _<_: promote  _u_: up     _q_: quit
 _h_ ^+^ _l_   _H_ ^+^ _L_   _b_ ^+^ _f_      _B_ ^+^ _F_       _>_: demote   _d_: down
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^   ^ ^ _n_ ^ ^      ^ ^ _N_ ^ ^
"
  ("h" org-metaleft)
  ("l" org-metaright)
  ("j" org-metadown)
  ("k" org-metaup)
  ("H" org-shiftleft)
  ("L" org-shiftright)
  ("J" org-shiftdown)
  ("K" org-shiftup)
  ("b" org-shiftmetaleft)
  ("f" org-shiftmetaright)
  ("n" org-shiftmetadown)
  ("p" org-shiftmetaup)
  ("B" org-shiftcontrolleft)
  ("F" org-shiftcontrolright)
  ("P" org-shiftcontroldown)
  ("N" org-shiftcontrolup)
  ("<" org-promote)
  (">" org-demote)
  ("d" org-move-item-down)
  ("u" org-move-item-up)
  ("q" nil :color blue))

(defhydra sk/hydra-org-property (:color red
                                        :hint nil)
  "
 _i_: insert  _p_: property   _s_: set    _d_: delete    _t_: toggle    _q_: quit
"
  ("i" org-insert-drawer)
  ("p" org-insert-property-drawer)
  ("s" org-set-property)
  ("d" org-delete-property)
  ("t" org-toggle-ordered-property)
  ("q" nil :color blue))
(defhydra sk/hydra-org-clock (:color red
                                     :hint nil)
  "
 ^Clock^                     ^Timer^     ^Stamp^
^^^^^^^^^^-------------------------------------------------
 _i_: in       _z_: resolve    _b_: begin  _t_: stamp       _q_: quit
 _o_: out      _l_: last       _e_: end    _u_: inactive
 _r_: report   _c_: cancel     _m_: timer
 _d_: display  _g_: goto       _s_: set
"
  ("i" org-clock-in)
  ("o" org-clock-out)
  ("r" org-clock-report)
  ("z" org-resolve-clocks)
  ("c" org-clock-cancel)
  ("d" org-clock-display)
  ("l" org-clock-in-last)
  ("g" org-clock-goto)
  ("m" org-timer)
  ("s" org-timer-set-timer)
  ("b" org-timer-start)
  ("e" org-timer-stop)
  ("t" org-time-stamp)
  ("u" org-time-stamp-inactive)
  ("q" nil :color blue))
(defhydra sk/hydra-org-jump (:color pink
                                    :hint nil)
  "
 ^Outline^          ^Item^   ^Table^   ^Block^   ^Link^
 ^^^^^^^^^^^-------------------------------------------------------------------------------
 ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^   ^ ^ _u_ ^ ^   ^ ^ ^ ^ ^ ^   ^ ^ _p_ ^ ^   ^ ^ _P_ ^ ^    _q_ quit
 _h_ ^+^ _l_   ^ ^ ^+^ ^ ^   ^ ^ ^+^ ^ ^   _b_ ^+^ _f_   ^ ^ ^+^ ^ ^   ^ ^ ^+^ ^ ^
 ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^   ^ ^ _d_ ^ ^   ^ ^ ^ ^ ^ ^   ^ ^ _n_ ^ ^   ^ ^ _N_ ^ ^
"
  ("j" outline-next-visible-heading)
  ("k" outline-previous-visible-heading)
  ("l" org-down-element)
  ("h" org-up-element)
  ("J" org-forward-heading-same-level)
  ("K" org-backward-heading-same-level)
  ("u" org-next-item)
  ("d" org-previous-item)
  ("f" org-table-next-field)
  ("b" org-table-previous-field)
  ("n" org-next-block)
  ("p" org-previous-block)
  ("N" org-next-link)
  ("P" org-previous-link)
  ("q" nil :color blue))
(defhydra hydra-org-template (:color blue :hint nil)
  "
_c_enter  _q_uote    _L_aTeX:
_l_atex   _e_xample  _i_ndex:
_a_scii   _v_erse    _I_NCLUDE:
_s_rc     eq_u_ation _H_TML:
_h_tml    ^ ^        _A_SCII:
"
  ("s" (hot-expand "<s"))
  ("e" (hot-expand "<e"))
  ("q" (hot-expand "<q"))
  ("v" (hot-expand "<v"))
  ("c" (hot-expand "<c"))
  ("l" (hot-expand "<l"))
  ("h" (hot-expand "<h"))
  ("a" (hot-expand "<a"))
  ("L" (hot-expand "<L"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("H" (hot-expand "<H"))
  ("A" (hot-expand "<A"))
  ("t" (hot-expand "<t"))
  ("u" (org-insert-env "equation"))
  ("<" self-insert-command "ins")
  ("o" nil "quit"))

(defhydra hydra-lisp-eval (:color blue :columns 2 :idle 1.0)
  "Lisp Eval"
  ("r" eval-region "Region")
  ("b" eval-buffer "Buffer")
  ("e" eval-expression "S-expression")
  ("l" eval-last-sexp "Last S-expression")
  ("L" eval-last-sexp-print-value "Last S-expression and Print Value")
  ("d" eval-defun "Defun / Function")
  ("f" eval-defun "Defun / Function"))

(defhydra hydra-sp (:color red :columns 8)
  "Smartparens"
  ("h" sp-backward-slurp-sexp "backward-slurp")
  ("j" sp-backward-barf-sexp "backward-barf")
  ("k" sp-forward-barf-sexp "forward-barf")
  ("l" sp-forward-slurp-sexp "forward-slurp")
  ("s" sp-splice-sexp "forward-slurp")
  ("9" asok/sp-wrap-with-parenthesis "wrap (" :exit t)
  ("[" asok/sp-wrap-with-square-brackets "wrap [" :exit t)
  ("{" asok/sp-wrap-with-curly-braces "wrap {" :exit t)
  ("'" asok/sp-wrap-with-quotes "wrap \"" :exit t)
  ("n" sp-forward-sexp "forward sexp")
  ("p" sp-backward-sexp "backward sexp")
  )

(defhydra hydra-magit (:color blue :columns 8)
  "Magit"
  ("s" magit-status "status")
  ("c" magit-checkout "checkout")
  ("f" magit-fetch-popup "fetch")
  ("v" magit-branch-manager "branch manager")
  ("m" magit-merge "merge")
  ("m" magit-push-popup "push")
  ("l" magit-log "log")
  ("!" magit-git-command "command")
  ("$" magit-process "process"))

(defhydra hydra-hl (:color blue :columns 8)
  "Highlight"
  ("s" highlight-symbol-at-point "symbol at point")
  ("r" highlight-regexp "regexp")
  ("i" highlight-indentation-mode "indentation")
  ("h" hi-lock-mode "toggle hi-lock-mode"))

;; from https://github.com/asok/.emacs.d/blob/master/inits/init-hydra.el
(setq grim/hydra-global-heads
      '(
        ("0" delete-window "delete window")
        ("1" delete-other-windows "delete other windows")
        ("2" split-window-below "split horizontally")
        ("3" split-window-right "split vertically")
        ("#" server-edit "server edit")
        ("w" spacemacs/window-manipulation-transient-state/body "window")
        ("l" hydra-sp/body "sp")
        ("s" save-buffer "save")
        ("o" counsel-mark-ring "mark ring")
        ("k" counsel-yank-pop "kill ring")
        ("f" counsel-find-file "find files")
        ("d" dired "dired")
        ("x" counsel-M-x "M-x")
        ("b" ivy-switch-buffer "ivy switch buffer")
        ("." ivy-resume "ivy resume")
        ;; ("g" hydra-engine/body "engine")
        ("g" hydra-magit/body "magit")
        ("a" spacemacs/search-project-rg "rg project")
        ("A" spacemacs/search-rg "rg dir")
        ("SPC" avy-goto-char "avy")
        ("8" hydra-hl/body "highlight")
        ("*" swiper "swiper")
        ("p" hydra-projectile/body "projectile")
        ("e" hydra-lisp-eval/body "eval")
        ("h" hydra-help/body "help")
        )
      )
(eval
 `(defhydra hydra-spawn-global (:color blue :columns 8)
    "Hydra"
    ,@grim/hydra-global-heads))
(provide 'grim-hydras)
