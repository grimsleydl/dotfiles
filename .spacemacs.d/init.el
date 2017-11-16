;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '("~/.spacemacs.d/")
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   grim--layers
   '(
     (emacs-lisp)
     (ivy)
     (auto-completion :variables
                      auto-completion-enable-sort-by-usage t
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t
                      ;; auto-completion-return-key-behavior nil)
                      )
     (autohotkey)
     (better-defaults)
     (command-log)
     (colors)
     ;; (dash)
     ;; (docker)
     ;; deft
     ;; emoji
     (evil-cleverparens)
     (evil-commentary)
     (evil-snipe :variables
                 evil-snipe-enable-alternate-f-and-t-behaviors t)
     ;; eyebrowse
     (git)
     (github)
     ;; (haskell :variables
     ;;          haskell-enable-hindent-style "chris-done")
     ;; (html :variables
     ;;       scss-compile-at-save nil)
     (ibuffer)
     (imenu-list)
     (javascript)
     ;; (latex :variables
     ;;        latex-enable-folding t
     ;;        latex-enable-auto-fill t)
     (markdown)
     ;; (nginx)
     (nlinum)
     ;; (org :variables
     ;;      org-enable-reveal-js-support t)
     (org :variables
          org-want-todo-bindings t)
     ;; origami
     (pandoc)
     ;; (python)
     ;; (ipython-notebook)
     ;; (ranger)
     ;; (search-engine)
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     (shell-scripts)
     ;; (speed-reading)
     (syntax-checking)
     (themes-megapack)
     ;; unimpaired
     ;; (version-control)
     (vim-empty-lines)
     (windows-scripts)
     (writeroom)
     ;; (yaml)
     (elixir)
     (elm :variables
          elm-sort-imports-on-save t
          ;; elm-format-command ;; "elm-format-0.18"
          )
     ;; (fsharp)
     (treemacs)
     (yaml)
     )
   )

  (setq
   grim--windows-layers
   '(
     (grim :variables
              grim--windows t
              grim--osx nil
              grim--unix nil)
     )
   grim--darwin-layers
   '(
     osx
     (grim :variables
              grim--osx t            ; bound by osx layer
              grim--windows nil
              grim--unix nil)
     ;; (ruby :variables ruby-version-manager 'chruby
     ;;       ruby-enable-enh-ruby-mode nil)
     )
   grim--gnu/linux-layers
   '(
     (grim :variables
              grim--windows t
              grim--osx nil
              grim--unix t)
     ;; (ruby :variables ruby-version-manager 'chruby
     ;; ruby-enable-enh-ruby-mode nil)
     )
   grim--personal-layers
   '(
     (grim-org)
     )
   )
  (cond ((eq system-type 'windows-nt)
         (setq grim--layers (append grim--layers grim--windows-layers)))
        ((eq system-type 'darwin)
         (setq grim--layers (append grim--layers grim--darwin-layers)))
        ((eq system-type 'gnu/linux)
         (setq grim--layers (append grim--layers grim--gnu/linux-layers))))
  (setq grim--layers (append grim--layers grim--personal-layers))
  ;; (when (member system-name grim-work-systems)
  ;;   (setq grim--layers (append grim-layers grim-work-layers)))

  (setq-default
   dotspacemacs-configuration-layers grim--layers

   dotspacemacs-additional-packages '(all-the-icons
                                      ;; fancy-narrow
                                      ;; darkroom
                                      dired-k
                                      draft-mode
                                      electric-spacing
                                      evil-embrace
                                      evil-goggles
                                      evil-smartparens
                                      fancy-narrow
                                      focus
                                      fzf
                                      helpful
                                      ;; hideshow-orgmode
                                      imenu-anywhere
                                      indent-tools
                                      ivy-rich
                                      key-chord
                                      kill-or-bury-alive
                                      magithub
                                      ;; nlinum
                                      olivetti
                                      org-bookmark-heading
                                      org-brain
                                      (org-bullets :location (recipe :fetcher github :repo "notetiene/org-bullets"))
                                      ;; org-dashboard
                                      ;; org-doing
                                      org-journal
                                      ;; org-page
                                      ;; org-recipes
                                      ;; palimpsest
                                      paper-theme
                                      quickrun
                                      ;; related
                                      ;; (global-set-key (kbd "<your key seq>") 'related-switch-forward)
                                      ;; (global-set-key (kbd "<your key seq>") 'related-switch-backward)
                                      ;; You might also want to try related-switch-buffer, which prompt you
                                      ;; for the next related buffer to go to (no default key binding here).
                                      terminal-here
                                      tiny
                                      unfill
                                      ;; vimish-fold
                                      wc-mode
                                      writegood-mode
                                      )

   dotspacemacs-excluded-packages '(evil-unimpaired)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5
   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default nil)
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-mode-enable-evilified-state t
                                       hybrid-mode-enable-hjkl-bindings nil
                                       hybrid-mode-use-evil-search-module nil
                                       hybrid-mode-default-state 'normal)
   ;; If non-nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (bookmarks . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'org-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(gruvbox
                         darktooth
                         material
                         material-light
                         spacemacs-dark
                         spacemacs-light
                         leuven
                         )
   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   ;; dotspacemacs-default-font '("Source Code Pro"
   dotspacemacs-default-font '("Fira Code"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non-nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ t
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, `J' and `K' move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text t
   ;; If non-nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non-nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non-nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non-nil, the paste transient-state is enabled. While enabled, pressing
   ;; `p' several times cycles through the elements in the `kill-ring'.
   ;; (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non-nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis t
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"
   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil
   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

  (add-to-list 'load-path "~/.spacemacs.d/config/")
  (defvar lou-the-gc-max (* 512 1024 1024)
    "Maximum Size of garbage collector.  Half gig seems reasonable.
This value is basically not sane.")

  (defvar lou-the-gc-sane (* 100 1024 1024)
    "Sane GC Value, 100MiB")

  (defvar lou-the-gc-default (* 800 1024)
    "Default GC value")

  (defvar lou-is-chatty nil
    "Whether or not Lou is chatty about debug messages")

  (defun lou-the-gc-go-crazy ()
    "Tell Lou the garbage collector to use maximum garbage size"
    (when lou-is-chatty
      (with-current-buffer (messages-buffer)
        (let ((inhibit-read-only t))
          (goto-char (point-max))
          (insert "\nLou is going crazy!"))))
    (setq gc-cons-threshold lou-the-gc-max))

  (defun lou-the-gc-be-sane ()
    "Tell Lou to stop acting crazy and use a sane garbage collection ammount"
    (when lou-is-chatty
      (with-current-buffer (messages-buffer)
        (let ((inhibit-read-only t))
          (goto-char (point-max))
          (insert "\nLou is sane again."))))

    (setq gc-cons-threshold lou-the-gc-sane))

  (defun lou-the-gc-default ()
    "Tell Lou to stop acting crazy and use a sane garbage collection amount"
    (when lou-is-chatty
      (with-current-buffer (messages-buffer)
        (let ((inhibit-read-only t))
          (goto-char (point-max))
          (insert "\nLou is sane again."))))

    (setq gc-cons-threshold lou-the-gc-default))

  (unless after-init-time
    (lou-the-gc-go-crazy)
    (add-hook 'emacs-startup-hook #'lou-the-gc-be-sane t))

  (add-hook 'minibuffer-setup-hook #'lou-the-gc-go-crazy)
  (add-hook 'minibuffer-exit-hook #'lou-the-gc-be-sane)

  ;; (setenv "WORKON_HOME" "~/Anaconda3/envs")
  ;; (defun my-minibuffer-setup-hook ()
  ;;   (setq gc-cons-threshold 100000000))
  ;; (defun my-minibuffer-exit-hook ()
  ;;   (setq gc-cons-threshold 12000000))

  ;; (add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
  ;; (add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

  )

(defun dotspacemacs/user-config ()
  "Configuration  for user code:
This function is called at the very end of Spacemacs startup, after
layer configuration.
Put your configuration code here, except for variables that  should be set before packages are loaded."
  (require 'grim-hydras)
  (setq-default line-spacing 0)
  ;; (setq python-shell-native-complete nil)
  ;; (setq jedi:server-command
  ;;       `("python"
  ;;         ,(concat (file-name-directory
  ;;                   (buffer-file-name
  ;;                    (car
  ;;                     (find-definition-noselect 'jedi:setup nil))))
  ;;                  "jediepcserver.py")))
  ;; (add-hook 'python-mode-hook 'jedi:setup)

  (use-package evil-embrace
    :config
    (evil-embrace-enable-evil-surround-integration))
  ;; (spacemacs/load-theme 'gruvbox)
  (setq password-cache-expiry nil)
  (setq tramp-use-ssh-controlmaster-options nil)
  (setq tramp-default-method "sshx")
  ;; (add-to-list 'tramp-default-proxies-alist
  ;;              '(nil "\\`root\\'" "/ssh:%h:"))
  ;; (add-to-list 'tramp-default-proxies-alist
  ;;              '((regexp-quote (system-name)) nil nil))

  ;; (add-to-list 'tramp-default-proxies-alist
  ;;              '("45\\.55\\.213\\.17" "\\`root\\'" "/plink:%h:"))

  (global-hungry-delete-mode)
  ;; (add-hook 'visual-line-mode-hook 'visual-fill-column-mode)
  (setq gruvbox-contrast 'hard)
  (global-prettify-symbols-mode 1)
  (setq w32-get-true-file-attributes nil)

  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
        (cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
            browse-url-generic-args     cmd-args
            browse-url-browser-function 'browse-url-generic)))

  (setq visual-fill-column-center-text t)
  (setq scroll-margin 8)

  (spacemacs/toggle-evil-cleverparens-on)
  (setq golden-ratio-auto-scale nil)
  ;; (setq helm-echo-input-in-header-line nil)
  (setq visual-fill-column-width 100)
  (setq scroll-conservatively 101)

  (add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))

  (setq ivy-ignore-buffers (quote ("\\` " "_archive")))
  (setq ivy-count-format "%d/%d ")
  ;; (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (setq ivy-initial-inputs-alist nil)
  (ivy-set-actions
   'counsel-describe-function
   '(("h" ejmr-helpful-try-all "Helpful")))
   (ivy-set-actions
   'counsel-find-file
   '(("d" delete-file "delete")))
  (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer)
  (setq ivy-rich-abbreviate-paths t)
  (setq ivy-rich-switch-buffer-name-max-length 40)
  (setq ivy-virtual-abbreviate 'full
        ivy-rich-switch-buffer-align-virtual-buffer t)

  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-comment-style 2)
  (setq css-indent-offset 2)
  (setq js-indent-level 2)
  (setq coffee-tab-width 2)
  (setq show-paren-style 'parenthesis)
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (setq-default evil-escape-key-sequence "jk")
  (defun my-read-passwd (read-passwd &rest args)
    "Inhibit evil-escape"
    (let ((evil-escape-inhibit t))
      (apply read-passwd args)))
  (advice-add 'read-passwd :around #'my-read-passwd)

  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)

  ;; (global-company-mode)
  (setq deft-directory "~/Dropbox/org/personal/notes")
  (setq deft-use-filter-string-for-filename t)
  (setq haskell-stylish-on-save t)

  ;; '(midnight-mode t nil (midnight))

  (add-hook 'focus-out-hook 'garbage-collect)
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
  (remove-hook 'find-file-hook 'vc-refresh-state)

  (add-hook 'text-mode-hook
            #'endless/config-prose-completion)

  (add-hook 'org-mode-hook
            '(lambda ()
               ;; make the lines in the buffer wrap around the edges of the screen.
               ;; (visual-line-mode)
               ;; (auto-fill-mode)
               (spacemacs/toggle-visual-line-navigation-on)
               (spacemacs/toggle-auto-fill-mode-on)
               (set-buffer-variable-pitch)
               ;; (org-indent-mode)
               (setq fill-column 100)
               (spacemacs|diminish buffer-face-mode)
               )
            )
  ;; (add-hook 'org-mode-hook 'wc-mode)
  ;; Haskell
  (when (configuration-layer/layer-usedp 'haskell)
    (add-hook 'haskell-interactive-mode-hook
              (lambda ()
                (setq-local evil-move-cursor-back nil))))
  (when (configuration-layer/layer-usedp 'haskell)
    (defadvice haskell-interactive-switch (after spacemacs/haskell-interactive-switch-advice activate)
      (when (eq dotspacemacs-editing-style 'vim)
        (call-interactively 'evil-insert))))
  ;; (with-eval-after-load 'org
  ;;   )
  (setq imenu-list-position 'left)

  ;; (shackle-mode t)
  ;; (setq shackle-rules
  ;;       '(("*helm-ag*"              :select t   :align right :size 0.5)
  ;;         ("*helm semantic/imenu*"  :select t   :align right :size 0.4)
  ;;         ("*helm org inbuffer*"    :select t   :align right :size 0.4)
  ;;         (flycheck-error-list-mode :select nil :align below :size 0.25)
  ;;         (ert-results-mode         :select t   :align below :size 0.5)
  ;;         (calendar-mode            :select t   :align below :size 0.25)
  ;;         (racer-help-mode          :select t   :align right :size 0.5)
  ;;         (help-mode                :select t   :align right :size 0.5)
  ;;         (helpful-mode             :select t   :align right :size 0.5)
  ;;         (compilation-mode         :select t   :align right :size 0.5)
  ;;         ("*Org Select*"           :select t   :align below :size 0.33)
  ;;         ("*Org Note*"             :select t   :align below :size 0.33)
  ;;         ("*Org Links*"            :select t   :align below :size 0.2)
  ;;         (" *Org todo*"            :select t   :align below :size 0.2)
  ;;         ("*Man.*"                 :select t   :align below :size 0.5  :regexp t)
  ;;         ("*helm.*"                :select t   :align below :size 0.33 :regexp t)
  ;;         ("*Org Src.*"             :select t   :align below :size 0.5  :regexp t)))
  )

(setq custom-file "~/.spacemacs.d/custom.el")
(load custom-file 'noerror)
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not write anything past this comment.
This  is where Emacs will
;; auto-generate custom variable definitions."
  )
