;; Meta-x
(global-set-key (kbd "<menu>") 'helm-M-x) ;; Unix
(global-set-key (kbd "<apps>") 'helm-M-x) ;; Windows


(global-set-key "," #'smart-self-insert-punctuation)

(global-set-key [remap fill-paragraph]
                #'endless/fill-or-unfill)
(global-set-key (kbd "M-SPC") 'k20e/cycle-spacing)


(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)


(define-key ivy-minibuffer-map (kbd "M-j") 'bjm/ivy-yank-whole-word)



;; (add-hook 'prog-mode-hook 'origami-mode)
;; (evil-nnoremap "F" 'origami-recursively-toggle-node)
;; (spacemacs/set-leader-keys "fo" 'origami-open-node)
;; (spacemacs/set-leader-keys "fO" 'origami-open-all-nodes)
;; (spacemacs/set-leader-keys "fc" 'origami-close-node)
;; (spacemacs/set-leader-keys "fC" 'origami-close-all-nodes)
;; (spacemacs/set-leader-keys "fn" 'origami-show-only-node)

;; (define-key evil-visual-state-map (kbd ", n n") #'narrow-or-widen-dwim)

(spacemacs/set-leader-keys "ba" 'grim/nuke-all-buffers
  "nd" 'narrow-or-widen-dwim
  "od" 'kill-or-bury-alive
  "oD" 'sk/goto-closest-number
  "oi" 'sk/mark-inside-subtree

  "on" 'grim/narrow-to-region-indirect

  "oO" 'grim/newline-above-below
  "op" 'grim/paste-newline-below
  "oP" 'grim/paste-newline-above
  "ou" 'hydra-undo-tree/body
  "oy" 'grim/my-copy-simple
  "fF" 'counsel-fzf
  "d SPC" 'counsel-dired-jump
  "f SPC" 'counsel-file-jump
  )
(evil-define-operator evil-narrow-indirect (beg end type)
  "Indirectly narrow the region from BEG to END."
  (interactive "<R>")
  (evil-normal-state)
  (grim/narrow-to-region-indirect beg end))
(define-key evil-normal-state-map "m" 'evil-narrow-indirect)
(define-key evil-visual-state-map "m" 'evil-narrow-indirect)

(define-key dired-mode-map "." 'hydra-dired/body)
(define-key dired-mode-map (kbd "C-s") 'hydra-dired-quick-sort/body)
(define-key dired-mode-map (kbd "C-,") 'dired-k)
;; (bind-key "C-y" #'hydra-yank-pop/yank)
;; (bind-key "M-y" #'hydra-yank-pop/yank-pop)
;; (bind-key "s-y" #'hydra-yank-pop/body)
;; (bind-key "C-s-y" #'counsel-yank-pop)

(bind-key "C-c C-e" #'hydra-lisp-eval/body emacs-lisp-mode-map)
(bind-key "C-c C-e" #'hydra-lisp-eval/body lisp-mode-map)

(global-set-key (kbd "<f1>") #'hydra-help/body)
(define-key evil-normal-state-map "U" 'hydra-undo-tree/body)
(define-key ivy-minibuffer-map "\C-o" 'soo-ivy/body)
