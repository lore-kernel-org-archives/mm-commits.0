From: akpm@linux-foundation.org
Subject: - maintainers-email-update-and-add-missing-entry.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:14 -0800
Message-ID: <200801160138.m0G1cEkP013891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35438 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbYAPBiV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: email update and add missing entry
has been removed from the -mm tree.  Its filename was
     maintainers-email-update-and-add-missing-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: email update and add missing entry
From: Nicolas Ferre <nicolas.ferre@atmel.com>

MAINTAINERS email update
add atmel_lcdfb entry

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                 |    8 +++++++-
 drivers/video/atmel_lcdfb.c |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-email-update-and-add-missing-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-email-update-and-add-missing-entry
+++ a/MAINTAINERS
@@ -665,12 +665,18 @@ S:	Maintained
 
 ATMEL AT91 MCI DRIVER
 P:	Nicolas Ferre
-M:	nicolas.ferre@rfo.atmel.com
+M:	nicolas.ferre@atmel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
 
+ATMEL LCDFB DRIVER
+P:	Nicolas Ferre
+M:	nicolas.ferre@atmel.com
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+S:	Maintained
+
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
diff -puN drivers/video/atmel_lcdfb.c~maintainers-email-update-and-add-missing-entry drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~maintainers-email-update-and-add-missing-entry
+++ a/drivers/video/atmel_lcdfb.c
@@ -801,5 +801,5 @@ module_init(atmel_lcdfb_init);
 module_exit(atmel_lcdfb_exit);
 
 MODULE_DESCRIPTION("AT91/AT32 LCD Controller framebuffer driver");
-MODULE_AUTHOR("Nicolas Ferre <nicolas.ferre@rfo.atmel.com>");
+MODULE_AUTHOR("Nicolas Ferre <nicolas.ferre@atmel.com>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch
