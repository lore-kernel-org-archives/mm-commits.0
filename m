From: akpm@linux-foundation.org
Subject: [to-be-updated]
 checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch removed
 from -mm tree
Date: Tue, 07 Jan 2014 15:21:12 -0800
Message-ID: <52cc8be8.37fXFoAKeLPNv1Zd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaAGXVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, josh@joshtriplett.org

Subject: [to-be-updated] checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch removed from -mm tree
To: josh@joshtriplett.org,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:21:12 -0800


The patch titled
     Subject: checkpatch-add-tests-for-function-pointer-style-misuses-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-add-tests-for-function-pointer-style-misuses-fix.patch

This patch was dropped because an updated version will be merged

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

checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch

