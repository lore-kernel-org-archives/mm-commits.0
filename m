From: akpm@linux-foundation.org
Subject: [folded] checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:48:37 -0800
Message-ID: <20120110224838.063AC5C0069@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61813 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2AJWsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:48:40 -0500
Received: by eekd41 with SMTP id d41so3142eek.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:48:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix up complex macros context format
has been removed from the -mm tree.  Its filename was
     checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context-fix.patch

This patch was dropped because it was folded into checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch

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

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
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
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch

