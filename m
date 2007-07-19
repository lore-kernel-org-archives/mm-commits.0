From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-isdn.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:43:18 -0700
Message-ID: <200707192343.l6JNhIai028913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757617AbXGSXne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:43:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, jengelh@gmx.de, kkeil@suse.de, tilman@imap.cc


The patch titled
     Use menuconfig objects: ISDN
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-isdn.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: ISDN
From: Jan Engelhardt <jengelh@computergmbh.de>

Unclutter the ISDN menu a tiny bit by moving ISDN4Linux and the CAPI2.0
layers into their own menu.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
use-menuconfig-objects-config_isdn_i4l.patch
use-menuconfig-objects-isdn.patch
use-menuconfig-objects-isdn-gigaset.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
