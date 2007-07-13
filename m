From: akpm@linux-foundation.org
Subject: - fix-gregkh-usb-usb-use-menuconfig-objects.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:19 -0700
Message-ID: <200707132233.l6DMXJ5H025071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936161AbXGMWp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, greg@kroah.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fix gregkh-usb-usb-use-menuconfig-objects
has been removed from the -mm tree.  Its filename was
     fix-gregkh-usb-usb-use-menuconfig-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix gregkh-usb-usb-use-menuconfig-objects
From: Jan Engelhardt <jengelh@computergmbh.de>

Generally, Jens Axboe was against 'default y', so I'll have some patches to
remove it.

Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/Kconfig~fix-gregkh-usb-usb-use-menuconfig-objects drivers/usb/Kconfig
--- a/drivers/usb/Kconfig~fix-gregkh-usb-usb-use-menuconfig-objects
+++ a/drivers/usb/Kconfig
@@ -5,7 +5,6 @@
 menuconfig USB_SUPPORT
 	bool "USB support"
 	depends on HAS_IOMEM
-	default y
 
 if USB_SUPPORT
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
make-timespec_equal-take-const-arguments.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
