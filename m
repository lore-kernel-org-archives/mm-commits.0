From: akpm@linux-foundation.org
Subject: + mmc-sdio-add-vendor-and-product-pair-for-sqn1130.patch added to -mm tree
Date: Fri, 07 Mar 2008 02:44:32 -0800
Message-ID: <200803071044.m27AiWDJ018110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbYCGKp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 05:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@smile.org.ua, drzeus@drzeus.cx, nico@cam.org


The patch titled
     mmc: sdio: add vendor and product pair for SQN1130
has been added to the -mm tree.  Its filename is
     mmc-sdio-add-vendor-and-product-pair-for-sqn1130.patch

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

