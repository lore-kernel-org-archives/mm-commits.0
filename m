From: akpm@linux-foundation.org
Subject: + fix-gregkh-usb-usb-use-menuconfig-objects.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:14:59 -0700
Message-ID: <200706272114.l5RLExS3007274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbXF0VPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, greg@kroah.com


The patch titled
     fix gregkh-usb-usb-use-menuconfig-objects
has been added to the -mm tree.  Its filename is
     fix-gregkh-usb-usb-use-menuconfig-objects.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix gregkh-usb-usb-use-menuconfig-objects
From: Jan Engelhardt <jengelh@computergmbh.de>

Generally, Jens Axboe was against 'default y', so I'll have some patches to
remove it.

Cc: Greg KH <greg@kroah.com>
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

use-menuconfig-objects-ii-scsi-fix.patch
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
