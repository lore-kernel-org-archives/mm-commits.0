From: akpm@linux-foundation.org
Subject: - fix-apparent-typo-config_usb_cdcether.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:51:41 -0800
Message-ID: <200702150851.l1F8pfor025311@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965559AbXBOIwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Fix apparent typo CONFIG_USB_CDCETHER
has been removed from the -mm tree.  Its filename was
     fix-apparent-typo-config_usb_cdcether.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix apparent typo CONFIG_USB_CDCETHER
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_USB_CDCETHER with CONFIG_USB_NET_CDCETHER.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/otg_whitelist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/otg_whitelist.h~fix-apparent-typo-config_usb_cdcether drivers/usb/core/otg_whitelist.h
--- a/drivers/usb/core/otg_whitelist.h~fix-apparent-typo-config_usb_cdcether
+++ a/drivers/usb/core/otg_whitelist.h
@@ -31,7 +31,7 @@ static struct usb_device_id whitelist_ta
 { USB_DEVICE_INFO(7, 1, 3) },
 #endif
 
-#ifdef	CONFIG_USB_CDCETHER
+#ifdef	CONFIG_USB_NET_CDCETHER
 /* Linux-USB CDC Ethernet gadget */
 { USB_DEVICE(0x0525, 0xa4a1), },
 /* Linux-USB CDC Ethernet + RNDIS gadget */
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
