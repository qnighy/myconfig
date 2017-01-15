(if (fboundp 'tool-bar-mode)
    (tool-bar-mode 0))
(menu-bar-mode 0)
(setq inhibit-startup-screen -1)
(setq initial-scratch-message "")
(display-time)
(column-number-mode t)
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)
; (standard-display-ascii ?\t ">-------")
(setq backup-directory-alist '(("" . "~/tmp")))

(add-to-list 'load-path (concat myconfig-site-lisp "/helm"))
(require 'helm-config)
(setq jaspace-alternate-eol-string "\xab\n")
(setq jaspace-highlight-tabs t)

(global-unset-key [prior])
(global-unset-key [next])
(global-unset-key [home])
(global-unset-key [end])
(global-unset-key (quote [67108896])) ; C-SPC


(setq frame-title-format (format "E>%%f@%s" (system-name)))

(show-paren-mode 1)
(blink-cursor-mode t)

