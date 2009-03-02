From: akpm@linux-foundation.org
Subject: [merged] checkpatch-extend-attribute-testing-to-all-modifiers.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:20 -0800
Message-ID: <200903021923.n22JNKx0014401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbZCBTaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: extend attribute testing to all modifiers
has been removed from the -mm tree.  Its filename was
     checkpatch-extend-attribute-testing-to-all-modifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: extend attribute testing to all modifiers
From: Andy Whitcroft <apw@canonical.com>

We should allow testing of all modifiers not just attributes.  Extend
testing and test for all the know modifiers.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-extend-attribute-testing-to-all-modifiers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-extend-attribute-testing-to-all-modifiers
+++ a/scripts/checkpatch.pl
@@ -1584,9 +1584,9 @@ sub process {
 		}
 # TEST: allow direct testing of the attribute matcher.
 		if ($dbg_attr) {
-			if ($line =~ /^.\s*$Attribute\s*$/) {
+			if ($line =~ /^.\s*$Modifier\s*$/) {
 				ERROR("TEST: is attr\n" . $herecurr);
-			} elsif ($dbg_attr > 1 && $line =~ /^.+($Attribute)/) {
+			} elsif ($dbg_attr > 1 && $line =~ /^.+($Modifier)/) {
 				ERROR("TEST: is not attr ($1 is)\n". $herecurr);
 			}
 			next;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
linux-next.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume.patch
psmouse-synaptics-ensure-we-reset-the-device-on-resume-fix.patch

