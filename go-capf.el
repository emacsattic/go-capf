;;; go-capf.el --- completion-at-point backend for go -*- lexical-binding: t -*-

;; Author: Philip K. <philip@warpmail.net>
;; Version: 0.1.0
;; Keywords: languages, abbrev, convenience
;; Package-Requires: ((emacs "24.4"))
;; URL: https://git.sr.ht/~zge/go-capf

;; This file is NOT part of Emacs.
;;
;; This file is in the public domain, to the extent possible under law,
;; published under the CC0 1.0 Universal license.
;;
;; For a full copy of the CC0 license see
;; https://creativecommons.org/publicdomain/zero/1.0/legalcode

;;; Commentary:
;;
;; Emacs built-in `completion-at-point' completion mechanism has no
;; support for go by default. This package helps solve the problem by
;; with a custom `completion-at-point' function, that should be added to
;; `completion-at-point-functions' as so:
;;
;;   (add-to-list 'completion-at-point-functions #'go-completion-at-point-function)
;;
;; Note that this requires gocode (https://github.com/mdempsky/gocode)
;; to be installed on your system, that's compatible with the version of
;; go you are using.

;;; Code:

(defgroup go-capf nil
  "Completion back-end for Go."
  :group 'completion
  :prefix "go-capf-")

(with-eval-after-load 'go-mode
  (add-hook 'kill-emacs-hook
            (lambda ()
              (when (file-exists-p (expand-file-name
                                    (concat "gocode-daemon." (or (getenv "USER") "all"))
                                    temporary-file-directory))
                (ignore-errors (call-process "gocode" nil nil nil "close"))))))

(defcustom go-capf-gocode (executable-find "gocode")
  "Path to gocode binary."
  :type 'file
  :group 'go-capf)

(defcustom go-capf-gocode-flags nil
  "Additional flags to pass to gocode."
  :type 'file
  :group 'go-capf)

(defun go-capf--completions (&rest _ignore)
  "Collect list of completions at point."
  (let* ((temp (generate-new-buffer " *gocode*")))
    (prog2
        (apply #'call-process-region
               (append (list (point-min) (point-max)
                             go-capf-gocode
                             nil temp nil)
                       go-capf-gocode-flags
                       (list "-f=sexp" "autocomplete"
                             (or (buffer-file-name) "")
                             (format "c%d" (- (point) 1)))))
        (with-current-buffer temp
          (goto-char (point-min))
          (mapcar #'cadr (read temp)))
      (kill-buffer temp))))

;;;###autoload
(defun go-completion-at-point-function ()
  "Return possible completions for go code at point."
  (unless go-capf-gocode
    (error "Binary \"gocode\" either not installed or not in path"))
  (list (save-excursion
          (unless (memq (char-before) '(?\. ?\t ?\n ?\ ))
            (forward-word -1))
          (point))
        (point)
        (completion-table-with-cache #'go-capf--completions)
        :exclusive 'no))

(provide 'go-capf)

;;; go-capf.el ends here
