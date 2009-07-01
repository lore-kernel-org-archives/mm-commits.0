From: akpm@linux-foundation.org
Subject: + usbnet-remove-private-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 16:07:04 -0700
Message-ID: <200907012307.n61N74D2020366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZGAXHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 19:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     usbnet: remove private stats structure
has been added to the -mm tree.  Its filename is
     usbnet-remove-private-stats-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cdc_eem-use-netdev-stats-structure.patch
dm9601-use-netdev-stats-structure.patch
net1080-use-netdev-stats-structure.patch
rndis_host-use-netdev-stats-structure.patch
smsc95xx-use-netdev-stats-structure.patch
usbnet-use-netdev-stats-structure.patch
usbnet-remove-private-stats-structure.patch

