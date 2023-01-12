;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Simon Scatton"
      user-mail-address "simon.scatton@epita.fr")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq doom-font (font-spec :family "Fira Code" :size 16))

;; Email configuration
(after! mu4e
  (set-email-account! "outlook"
                      '((mu4e-sent-folder       . "/outlook/Sent")
                        (mu4e-drafts-folder     . "/outlook/Drafts")
                        (mu4e-refile-folder     . "/outlook/Archive")
                        (mu4e-trash-folder      . "/outlook/Trash")
                        (user-mail-address      . "simon.scatton@outlook.fr")
                        (user-full-name         . "Simon Scatton")
                        (mu4e-compose-signature . "Simon Scatton"))
                      t)
  (set-email-account! "lrde"
                      '((mu4e-sent-folder       . "/lrde/Sent")
                        (mu4e-drafts-folder     . "/lrde/Drafts")
                        (mu4e-trash-folder      . "/lrde/Trash")
                        (user-mail-address      . "sscatton@lrde.epita.fr")
                        (user-full-name         . "Simon Scatton")
                        (mu4e-compose-signature . "Simon Scatton"))
                      nil)

  (set-email-account! "prologin"
                      '((mu4e-sent-folder       . "/prologin/Sent")
                        (mu4e-drafts-folder     . "/prologin/Drafts")
                        (mu4e-trash-folder      . "/prologin/Trash")
                        (user-mail-address      . "simon.scatton@prologin.org")
                        (user-full-name         . "Simon Scatton")
                        (mu4e-compose-signature . "Simon Scatton"))
                      nil)

  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail)

  (add-hook! mu4e-compose-mode
    (ws-butler-mode -1))
  (add-to-list 'mm-discouraged-alternatives "text/html")
  (add-to-list 'mm-discouraged-alternatives "text/richtext")

  (setq org-msg-options (concat org-msg-options " -:nil"))
  (setq org-msg-signature "\n#+begin_signature\n-- \\\\\nSimon Scatton\n#+end_signature")
  (setq org-msg-default-alternatives '((new utf-8)
                                       (reply-to-text utf-8)
                                       (reply-to-html utf-8)))
  (setq mu4e-compose-format-flowed nil)
  (setf (plist-get (alist-get 'trash mu4e-marks) :action)
        (lambda (docid msg target)
          (mu4e--server-move docid (mu4e--mark-check-target target) "-N"))) ; Instead of "+T-N"

  (setq mu4e-update-interval 300)
  (setq mu4e-headers-auto-update nil)
  (setq mu4e-compose-context-policy 'ask)
  (setq mu4e-headers-date-format "%d/%m/%y")
  (setq mu4e-headers-time-format "%T")

  (setq mu4e-headers-fields '((:account-stripe . 1)
                              ;; just enough room for dd/mm/yy or hh:mm:ss
                              (:human-date . 8)
                              (:flags . 6)
                              (:mailing-list . 30)
                              (:from-or-to . 30)
                              (:subject)))
  (setq mu4e-bookmarks '((:name "Unread messages" :query "flag:unread \
                                                                AND NOT maildir:/outlook/Sent \
                                                                AND NOT maildir:/prologin/Sent \
                                                                AND NOT maildir:/lrde/Sent \
                                                                AND NOT flag:trashed \
                                                                AND NOT maildir:/outlook/Junk \
                                                                AND NOT maildir:/prologin/Junk \
                                                                AND NOT maildir:/lrde/Junk"
                                                                :key ?u)
                         (:name "Today's messages" :query "date:today..now \
                                                                AND NOT maildir:/outlook/Sent \
                                                                AND NOT maildir:/prologin/Sent \
                                                                AND NOT maildir:/lrde/Sent \
                                                                AND NOT flag:trashed \
                                                                AND NOT maildir:/outlook/Junk \
                                                                AND NOT maildir:/prologin/Junk \
                                                                AND NOT maildir:/lrde/Junk"
                                                                :key ?t)
                         (:name "Last 7 days" :query "date:7d..now \
                                                                AND NOT maildir:/outlook/Sent \
                                                                AND NOT maildir:/prologin/Sent \
                                                                AND NOT maildir:/lrde/Sent \
                                                                AND NOT flag:trashed \
                                                                AND NOT maildir:/outlook/Junk \
                                                                AND NOT maildir:/prologin/Junk \
                                                                AND NOT maildir:/lrde/Junk"
                                                                :hide-unread t :key ?w)
                         (:name "All messages" :query "NOT flag:trashed \
                                                                AND NOT maildir:/outlook/Junk \
                                                                AND NOT maildir:/prologin/Junk \
                                                                AND NOT maildir:/lrde/Junk"
                                                                :key ?U)
                         (:name "Sent messages" :query "maildir:/outlook/Sent \
                                                        OR maildir:/prologin/Sent \
                                                        OR maildir:/lrde/Sent"
                                                        :key ?s)
                         ))

  (setq mu4e-maildir-shortcuts
        '( (:name "Outlook" :maildir "/outlook/Inbox" :key  ?m)
           (:name "LRDE" :maildir "/lrde/Inbox" :key  ?l)
           (:name "Prologin" :maildir "/prologin/Inbox" :key  ?p)))
  )
