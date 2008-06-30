From: akpm@linux-foundation.org
Subject: + checkpatch-correct-spelling-in-kfree-checks.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:19:50 -0700
Message-ID: <200806302219.m5UMJodZ028588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764181AbYF3WUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, apw@shadowen.org


The patch titled
     checkpatch: correct spelling in kfree checks
has been added to the -mm tree.  Its filename is
     checkpatch-correct-spelling-in-kfree-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

checkpatch-correct-spelling-in-kfree-checks.patch

