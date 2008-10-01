From: akpm@linux-foundation.org
Subject: - mmc-fix-comment-in-include-linux-mmc-hosth.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:42 -0700
Message-ID: <200810012150.m91Log1A005864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbYJAVur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     mmc: fix comment in include/linux/mmc/host.h
has been removed from the -mm tree.  Its filename was
     mmc-fix-comment-in-include-linux-mmc-hosth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: fix comment in include/linux/mmc/host.h
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

In include/linux/mmc/host.h, it is mentionned that the callback to know if
a card is present or not is get_ro().  But it's get_cd().

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmc/host.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmc/host.h~mmc-fix-comment-in-include-linux-mmc-hosth include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-comment-in-include-linux-mmc-hosth
+++ a/include/linux/mmc/host.h
@@ -65,7 +65,7 @@ struct mmc_host_ops {
 	 *   -ENOSYS when not supported (equal to NULL callback)
 	 *   or a negative errno value when something bad happened
 	 *
-	 * Return values for the get_ro callback should be:
+	 * Return values for the get_cd callback should be:
 	 *   0 for a absent card
 	 *   1 for a present card
 	 *   -ENOSYS when not supported (equal to NULL callback)
_

Patches currently in -mm which might be from thomas.petazzoni@free-electrons.com are

git-x86.patch
git-pci.patch
git-nfsd.patch
git-mmc.patch
configure-out-aio-support.patch
configure-out-aio-support-fix.patch

