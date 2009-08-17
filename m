From: akpm@linux-foundation.org
Subject: [merged] rt2870-new-usb-id-for-belkin-n-f5d8055.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:05:00 -0700
Message-ID: <200908172005.n7HK50Xk017715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666AbZHQUGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dnax88@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rt2870: new USB ID for Belkin N+ F5D8055
has been removed from the -mm tree.  Its filename was
     rt2870-new-usb-id-for-belkin-n-f5d8055.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rt2870: new USB ID for Belkin N+ F5D8055
From: Daniele Napolitano <dnax88@gmail.com>

New USB ID for Belkin N+ F5D8055 (USB 802.11n adapter).

Signed-off-by: Daniele Napolitano <dnax88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rt2870/rt2870.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rt2870/rt2870.h~rt2870-new-usb-id-for-belkin-n-f5d8055 drivers/staging/rt2870/rt2870.h
--- a/drivers/staging/rt2870/rt2870.h~rt2870-new-usb-id-for-belkin-n-f5d8055
+++ a/drivers/staging/rt2870/rt2870.h
@@ -102,6 +102,7 @@
 	{USB_DEVICE(0x14B2,0x3C12)}, /* AL */           \
 	{USB_DEVICE(0x050D,0x8053)}, /* Belkin */		\
 	{USB_DEVICE(0x050D,0x815C)}, /* Belkin */		\
+	{USB_DEVICE(0x050D,0x825a)}, /* Belkin */		\
 	{USB_DEVICE(0x14B2,0x3C23)}, /* Airlink */		\
 	{USB_DEVICE(0x14B2,0x3C27)}, /* Airlink */		\
 	{USB_DEVICE(0x07AA,0x002F)}, /* Corega */		\
_

Patches currently in -mm which might be from dnax88@gmail.com are

linux-next.patch

