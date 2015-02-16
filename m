From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-neaten-printk_ratelimited-message-position.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:17:31 -0800
Message-ID: <54e2505b.eO0IIFPX14vIXMrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbBPUSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: neaten printk_ratelimited message position
has been removed from the -mm tree.  Its filename was
     checkpatch-neaten-printk_ratelimited-message-position.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: neaten printk_ratelimited message position

Just neatening...

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-neaten-printk_ratelimited-message-position scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-neaten-printk_ratelimited-message-position
+++ a/scripts/checkpatch.pl
@@ -3243,7 +3243,7 @@ sub process {
 # check for uses of printk_ratelimit
 		if ($line =~ /\bprintk_ratelimit\s*\(/) {
 			WARN("PRINTK_RATELIMITED",
-"Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
+			     "Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

