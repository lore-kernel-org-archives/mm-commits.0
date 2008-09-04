From: akpm@linux-foundation.org
Subject: + mmc-fix-comment-in-include-linux-mmc-hosth.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:57:05 -0700
Message-ID: <200809042057.m84Kv57v030649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265AbYIDVEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.petazzoni@free-electrons.com


The patch titled
     mmc: fix comment in include/linux/mmc/host.h
has been added to the -mm tree.  Its filename is
     mmc-fix-comment-in-include-linux-mmc-hosth.patch

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

linux-next.patch
mmc-fix-comment-in-include-linux-mmc-hosth.patch
configure-out-igmp-support.patch
configure-out-aio-support.patch

