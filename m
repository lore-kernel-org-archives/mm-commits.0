From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-isdn.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:54 -0700
Message-ID: <200707230934.l6N9Yspf016432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759155AbXGWJp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, jengelh@gmx.de, kkeil@suse.de, tilman@imap.cc, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: ISDN
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-isdn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: ISDN
From: Jan Engelhardt <jengelh@computergmbh.de>

Unclutter the ISDN menu a tiny bit by moving ISDN4Linux and the CAPI2.0
layers into their own menu.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/isdn/Kconfig~use-menuconfig-objects-isdn drivers/isdn/Kconfig
--- a/drivers/isdn/Kconfig~use-menuconfig-objects-isdn
+++ a/drivers/isdn/Kconfig
@@ -21,7 +21,7 @@ menuconfig ISDN
 
 if ISDN
 
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
@@ -43,7 +43,7 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-config ISDN_CAPI
+menuconfig ISDN_CAPI
 	tristate "CAPI 2.0 subsystem"
 	help
 	  This provides the CAPI (Common ISDN Application Programming
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
