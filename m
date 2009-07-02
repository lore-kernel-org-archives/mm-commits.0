From: akpm@linux-foundation.org
Subject: [merged] usbnet-remove-private-stats-structure.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:34 -0700
Message-ID: <200907021833.n62IXYAT018249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbZGBSeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     usbnet: remove private stats structure
has been removed from the -mm tree.  Its filename was
     usbnet-remove-private-stats-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usbnet: remove private stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that nothing uses the private stats structure we can remove it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/usb/usbnet.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/usb/usbnet.h~usbnet-remove-private-stats-structure include/linux/usb/usbnet.h
--- a/include/linux/usb/usbnet.h~usbnet-remove-private-stats-structure
+++ a/include/linux/usb/usbnet.h
@@ -42,7 +42,6 @@ struct usbnet {
 
 	/* protocol/interface state */
 	struct net_device	*net;
-	struct net_device_stats	stats;
 	int			msg_enable;
 	unsigned long		data [5];
 	u32			xid;
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

