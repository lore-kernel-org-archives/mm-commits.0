From: akpm@linux-foundation.org
Subject: + checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch added to -mm tree
Date: Thu, 01 Dec 2011 12:56:31 -0800
Message-ID: <201112012056.pB1KuWPX011154@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46081 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LAU4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:56:35 -0500
Received: by eekd41 with SMTP id d41so19196eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:56:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: fix up complex macros context format
has been added to the -mm tree.  Its filename is
     checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: fix up complex macros context format

Fix a missing newline and correctly use the raw context for the
complex macro report.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix
+++ a/scripts/checkpatch.pl
@@ -2851,7 +2851,7 @@ sub process {
 					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx");
 				} else {
 					ERROR("COMPLEX_MACRO",
-					      "Macros with complex values should be enclosed in parenthesis\n" . "$here$ctx");
+					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
 		}
_
Subject: Subject: checkpatch: fix up complex macros context format

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch

