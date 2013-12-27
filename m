From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch added to
 -mm tree
Date: Fri, 27 Dec 2013 14:05:45 -0800
Message-ID: <52bdf9b9.KBmEZ44VNDg4442k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3L0WFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Dec 2013 17:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, josh@joshtriplett.org

Subject: + checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch added to -mm tree
To: josh@joshtriplett.org,joe@perches.com
From: akpm@linux-foundation.org
Date: Fri, 27 Dec 2013 14:05:45 -0800


The patch titled
     Subject: checkpatch-add-tests-for-function-pointer-style-misuses-fix
has been added to the -mm tree.  Its filename is
     checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: checkpatch-add-tests-for-function-pointer-style-misuses-fix

Fix an ambiguity in one warning message and a copy/paste problem in
another.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tests-for-function-pointer-style-misuses-fix
+++ a/scripts/checkpatch.pl
@@ -2827,7 +2827,7 @@ sub process {
 			if (defined $pre_pointer_space &&
 			    $pre_pointer_space =~ /^\s/) {
 				WARN("SPACING",
-				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);
+				     "Unnecessary space between open parenthesis and '*' in function pointer declaration\n" . $herecurr);
 			}
 
 # unnecessary space "type (* funcptr)(args...)"
@@ -2848,7 +2848,7 @@ sub process {
 			if (defined $pre_args_space &&
 			    $pre_args_space =~ /^\s/) {
 				WARN("SPACING",
-				     "Unnecessary space before function pointer name\n" . $herecurr);
+				     "Unnecessary space before function pointer argument list\n" . $herecurr);
 			}
 
 			if (show_type("SPACING") && $fix) {
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch

