From: akpm@linux-foundation.org
Subject: - checkpatch-correct-spelling-in-kfree-checks.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:34 -0700
Message-ID: <200807242326.m6ONQYWu010990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910AbYGXX0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: correct spelling in kfree checks
has been removed from the -mm tree.  Its filename was
     checkpatch-correct-spelling-in-kfree-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: correct spelling in kfree checks
From: Wolfram Sang <w.sang@pengutronix.de>

Correct spelling in the kfree reports.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-correct-spelling-in-kfree-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-correct-spelling-in-kfree-checks
+++ a/scripts/checkpatch.pl
@@ -2075,7 +2075,7 @@ sub process {
 		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
 			my $expr = $1;
 			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
+				WARN("kfree(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
 		}
 # check for needless usb_free_urb() checks
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch

