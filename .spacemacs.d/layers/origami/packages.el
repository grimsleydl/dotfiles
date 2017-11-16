;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <flomop@ya.ru>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst origami-packages
  '(origami))

(defun origami/init-origami ()
  (use-package origami
    :defer t
    ;; :init (define-key origami-mode-map (kbd "TAB") 'origami-toggle-node)))
    ))

;;; packages.el ends here
