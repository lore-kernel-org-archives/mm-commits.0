From: akpm@linux-foundation.org
Subject: - mmc-sdio-add-vendor-and-product-pair-for-sqn1130.patch removed from -mm tree
Date: Fri, 07 Mar 2008 02:44:55 -0800
Message-ID: <200803071044.m27AitHA018116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbYCGKpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 05:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy@smile.org.ua, drzeus@drzeus.cx, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     mmc: sdio: add vendor and product pair for SQN1130
has been removed from the -mm tree.  Its filename was
     mmc-sdio-add-vendor-and-product-pair-for-sqn1130.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: sdio: add vendor and product pair for SQN1130
From: Andy Shevchenko <andy@smile.org.ua>

Add the vendor and product ids for Sequans SQN1130 WiMAX chipset.

Cc: Nicolas Pitre <nico@cam.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmc/sdio_ids.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mmc/sdio_ids.h~mmc-sdio-add-vendor-and-product-pair-for-sqn1130 include/linux/mmc/sdio_ids.h
--- a/include/linux/mmc/sdio_ids.h~mmc-sdio-add-vendor-and-product-pair-for-sqn1130
+++ a/include/linux/mmc/sdio_ids.h
@@ -26,4 +26,7 @@
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
 
+#define SDIO_VENDOR_ID_SEQUANS			0x039d
+#define SDIO_DEVICE_ID_SEQUANS_SQN1130		0x046a
+
 #endif
_

Patches currently in -mm which might be from andy@smile.org.ua are

mmc-sdio-add-vendor-and-product-pair-for-sqn1130.patch

