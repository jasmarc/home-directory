(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;; If you've ever had your ass saved by an Emacs backup file, you
;; probably want more of them, not less of them. It is annoying that
;; they go in the same directory as the file you're editing, but
;; that is easy to change. You can make all backup files go into a
;; directory by putting something like the following in your .emacs.
(setq backup-directory-alist `(("." . "~/.saves")))

;; There are a number of arcane details associated with how Emacs
;; might create your backup files. Should it rename the original and
;; write out the edited buffer? What if the original is linked? In
;; general, the safest but slowest bet is to always make backups by
;; copying.
(setq backup-by-copying t)

;; If that's too slow for some reason you might also have a look at
;; backup-by-copying-when-linked.  Since your backups are all in
;; their own place now, you might want more of them, rather than
;; less of them. Have a look at the Emacs documentation for these
;; variables (with C-h v).
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

(setq savehist-additional-variables    ;; also save...
  '(search-ring regexp-search-ring)    ;; ... my search entries
  savehist-file "~/.emacs.d/savehist") ;; keep my home clean
(savehist-mode t)                      ;; do customization before activate

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

(add-to-list 'load-path "~/.emacs.d/")
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers 

(require 'whitespace)
(setq whitespace-style '(face trailing tabs tab-mark
                                  space-before-tab
                                  space-after-tab))
(global-whitespace-mode t)

(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(defun toggle-tabs ()
  "Toggles between using tabs vs. spaces"
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode)))

(defun reload-dotemacs-file ()
  "reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs"))