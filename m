From: akpm@linux-foundation.org
Subject: - fix-misspelled-usbnet_mii-kernel-config-option.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:36 -0800
Message-ID: <200702150851.l1F8paO5025305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965554AbXBOIvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Fix misspelled "USBNET_MII" kernel config option.
has been removed from the -mm tree.  Its filename was
     fix-misspelled-usbnet_mii-kernel-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix misspelled "USBNET_MII" kernel config option.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix the misspelling of "USBNET_MII" to "USB_USBNET_MII".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/net/Kconfig~fix-misspelled-usbnet_mii-kernel-config-option drivers/usb/net/Kconfig
--- a/drivers/usb/net/Kconfig~fix-misspelled-usbnet_mii-kernel-config-option
+++ a/drivers/usb/net/Kconfig
@@ -99,7 +99,7 @@ config USB_USBNET_MII
 
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USBNET_MII != n
+	select MII if USB_USBNET_MII != n
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
