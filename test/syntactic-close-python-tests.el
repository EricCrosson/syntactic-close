;;; syntactic-close-python-tests.el --- Python tests -*- lexical-binding: t; -*-

;; Authored and maintained by
;; Emacs User Group Berlin <emacs-berlin@emacs-berlin.org>

;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defvar syntactic-close-python-test-string-1 "\"Some Doku")
(setq syntactic-close-python-test-string-1 "\"Some Doku")

(defvar syntactic-close-python-test-string-2 "{[(123")
(setq syntactic-close-python-test-string-2 "{[(123")

(ert-deftest syntactic-close-python-doublequoted-test ()
  (syntactic-close-test-with-python-buffer
      syntactic-close-python-test-string-1
    ;; (message "%s" "Starte syntactic-close-python-doublequoted-test")
    (syntactic-close)
    (should (eq (char-before) ?\"))))

(ert-deftest syntactic-close-python-singlequoted-test ()
  (syntactic-close-test-with-python-buffer
      "'Some Doku"
    (message "%s" "syntactic-close-python-singlequoted-test")
    (syntactic-close)
    (should (eq (char-before) ?'))))

(ert-deftest syntactic-close-python-doublequoted-tqs-test ()
  (syntactic-close-test-with-python-buffer
      "\"\"\"Some Doku"
    (font-lock-fontify-buffer)
    ;; (message "%s" "Starte syntactic-close-python-doublequoted-tqs-test")
    (syntactic-close)
    (should (eq (char-before) ?\"))
    (should (eq -3 (skip-chars-backward "\"")))))

(ert-deftest syntactic-close-python-singlequoted-tqs-test ()
  (syntactic-close-test-with-python-buffer
      "'''Some Doku"
    (font-lock-fontify-buffer)
    ;; (message "%s" "Starte syntactic-close-python-singlequoted-tqs-test")
    (syntactic-close)
    (should (eq (char-before) ?'))
    (should (eq -3 (skip-chars-backward "'")))))

(ert-deftest syntactic-close-python-brace-paren-bracket-test-1 ()
  (syntactic-close-test-with-python-buffer
      syntactic-close-python-test-string-2
    ;; (message "%s" "Starte syntactic-close-python-brace-paren-bracket-test-1")
    (syntactic-close)
    (should (eq (char-before) ?\)))))

(ert-deftest syntactic-close-python-brace-paren-bracket-test-2 ()
  (syntactic-close-test-with-python-buffer
      syntactic-close-python-test-string-2
    (syntactic-close)
    (syntactic-close)
    (should (eq (char-before) ?\]))))

(ert-deftest syntactic-close-python-brace-paren-bracket-test-3 ()
  (syntactic-close-test-with-python-buffer
      syntactic-close-python-test-string-2
    (syntactic-close)
    (syntactic-close)
    (syntactic-close)
    (should (eq (char-before) ?}))))

(ert-deftest syntactic-close-delete-whitespace-backward-test ()
  (syntactic-close-test-with-python-buffer
      "[1, 3] "
    (let ((syntactic-close-delete-whitespace-backward-p t))
      (syntactic-close)
      (should (eq 8 (point)))
      (should (eq 0 (current-indentation))))))

(ert-deftest syntactic-close-python-nested-paren-test-1 ()
  (syntactic-close-test-with-python-buffer
      "(list ([\n# {123\n# {123\n"
    (syntactic-close)
    (should (eq (char-before) ?\]))))

(ert-deftest syntactic-close-python-nested-paren-test-2 ()
  (syntactic-close-test-with-python-buffer
      "(list ([\n# {123\n# {123\n]"
    (syntactic-close)
    (should (eq (char-before) ?\)))))

(ert-deftest syntactic-close-python-nested-paren-test-3 ()
  (syntactic-close-test-with-python-buffer
      "(list ([\n# {123\n# {123\n])"
    (syntactic-close)
    (should (eq (char-before) ?\)))))

(ert-deftest syntactic-close-python-string-interpolation-test-1 ()
  (syntactic-close-test-with-python-buffer "print('%(language"
    (syntactic-close)
    (should (eq (char-before) ?\)))))

;; https://www.python.org/dev/peps/pep-0498/
(ert-deftest syntactic-close-python-string-interpolation-test-2 ()
  (syntactic-close-test-with-python-buffer "print('%(language)s has %(number)03d quote types.' %
      {'language"
    (syntactic-close)
    (should (eq (char-before) ?'))))

(ert-deftest syntactic-close-python-string-interpolation-test-3 ()
  (syntactic-close-test-with-python-buffer "print('%(language)s has %(number)03d quote types.' %
      {'language': \"Python"
    (syntactic-close)
    (should (eq (char-before) ?\"))))

(ert-deftest syntactic-close-python-string-interpolation-test-4 ()
  (syntactic-close-test-with-python-buffer "print('%(language)s has %(number)03d quote types.' %
      {'language': \"Python\", \"number\": 2"
    (syntactic-close)
    (should (eq (char-before) ?}))))

(ert-deftest syntactic-close-python-string-interpolation-test-5 ()
  (syntactic-close-test-with-python-buffer "print('%(language)s has %(number)03d quote types.' %
      {'language': \"Python\", \"number\": 2}"
    (syntactic-close)
    (should (eq (char-before) ?\)))))

(ert-deftest syntactic-close-python-string-interpolation-test-6 ()
  ;; "return 'Point({self.x}, {self.y})'.format(self=self)"
  (syntactic-close-test-with-python-buffer "return 'Point({self.x"
    (syntactic-close)
    (should (eq (char-before) ?}))))

(ert-deftest syntactic-close-python-string-interpolation-test-7 ()
  ;; "return 'Point({self.x}, {self.y})'.format(self=self)"
  (syntactic-close-test-with-python-buffer "return 'Point({self.x}"
    (syntactic-close)
    (should (eq (char-before) ?\)))))

(ert-deftest syntactic-close-python-string-interpolation-test-8 ()
  ;; "return 'Point({self.x}, {self.y})'.format(self=self)"
  (syntactic-close-test-with-python-buffer "return 'Point({self.x})"
    (syntactic-close)
    (should (eq (char-before) ?'))))

(ert-deftest syntactic-close-python-no-colon-test-1 ()
  (syntactic-close-test-with-python-buffer
      "print(1)"
    (let ((orig (point)))
      (syntactic-close)
      (should (eq (char-before) ?\)))
      (should (eq (point) orig)))))

(ert-deftest syntactic-close-python-electric-test-1 ()
  (syntactic-close-test-with-python-buffer
      "['a"
    (let ((syntactic-close-electric-listify-p t))
      (syntactic-close)
      (should (eq (char-before) ?')))))

(ert-deftest syntactic-close-python-electric-test-4 ()
  (syntactic-close-test-with-python-buffer
      "['a','b'"
    (let ((syntactic-close-electric-listify-p t))
      ;; force final closing
      (syntactic-close '(4))
      (should (eq (char-before) ?\])))))

(ert-deftest syntactic-close-python-electric-test-6 ()
  (syntactic-close-test-with-python-buffer
      "[\"a\""
    (let ((syntactic-close-electric-listify-p t))
      (syntactic-close '(4))
      (should (eq (char-before) ?\])))))

(ert-deftest syntactic-close-python-electric-test-8 ()
  (syntactic-close-test-with-python-buffer
      "def potenz(x"
    (let ((syntactic-close-electric-listify-p t))
      (syntactic-close)
      (should (eq (char-before) ?\))))))

(ert-deftest syntactic-close-python-electric-test-10 ()
  (syntactic-close-test-with-python-buffer
      "def potenz(x,y"
    (let ((syntactic-close-electric-listify-p t))
      (syntactic-close '(4))
      (should (eq (char-before) ?\))))))


(provide 'syntactic-close-python-tests)

;;; syntactic-close-python-tests.el ends here
