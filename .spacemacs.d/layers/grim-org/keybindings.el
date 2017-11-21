;; F12 org capture/agenda (TEK/Mac=Louder)
(global-set-key [f12]                 'org-capture)
(global-set-key [(meta f12)]          'org-agenda)
(global-set-key [(shift f12)]         'org-ctrl-c-ctrl-c)

(with-eval-after-load 'evil-org
  (define-key org-mode-map [remap fill-paragraph] #'grim/org-fill-or-unfill)
  (define-key evil-org-mode-map (kbd "<normal-state> C-n") 'org-show-next-heading-tidily)
  (define-key evil-org-mode-map (kbd "<normal-state> C-p") 'org-show-previous-heading-tidily)
  (define-key org-mode-map [remap fill-paragraph] #'grim/org-fill-or-unfill)
  (define-key org-mode-map (kbd "C-c t") 'org-toggle-blocks)
  ;; (with-eval-after-load 'evil-org
  ;; (evil-define-key 'normal evil-org-mode-map "C-n" 'org-show-next-heading-tidily))
  (define-key org-mode-map (kbd "C-,") 'org-begin-template)
  (define-key org-mode-map "<"
    (defun org-self-insert-or-less ()
      (interactive)
      (if (looking-back "^")
         (hydra-org-template/body)
        (self-insert-command 1)))))

(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "l" 'org-show-current-heading-tidily
  "J" 'counsel-org-goto
  "j" 'org-show-next-heading-tidily
  "k" 'org-show-previous-heading-tidily
  "g" 'narrow-or-widen-dwim
  "oc" 'sk/hydra-org-clock/body
  "of" 'grim-org/reflash-indentation
  "oj" 'sk/hydra-org-jump/body
  "ol" 'hydra-org-link-edit/body
  "oL" 'my-org-insert-link
  "oo" 'sk/hydra-org-organize/body
  "op" 'sk/hydra-org-property/body
  "or" 'my/org-refile-and-jump
  "ot" 'hydra-org-template/body
  "oT" 'helm-org-capture-templates
  "so" 'helm-org-in-buffer-headings
  )
