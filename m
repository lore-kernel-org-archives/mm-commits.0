From: akpm@linux-foundation.org
Subject: - usb-remove-duplicate-id-in-ipaq-driver.patch removed from -mm tree
Date: Thu, 17 May 2007 12:50:01 -0700
Message-ID: <200705171950.l4HJo2Un031461@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377AbXEQTxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.collins@ubuntu.com, bcollins@ubuntu.com, ganesh@veritas.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: remove duplicate ID in ipaq driver
has been removed from the -mm tree.  Its filename was
     usb-remove-duplicate-id-in-ipaq-driver.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: usb: remove duplicate ID in ipaq driver
From: Ben Collins <ben.collins@ubuntu.com>

Cc: Ganesh Varadarajan <ganesh@veritas.com>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ipaq.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/serial/ipaq.c~usb-remove-duplicate-id-in-ipaq-driver drivers/usb/serial/ipaq.c
--- a/drivers/usb/serial/ipaq.c~usb-remove-duplicate-id-in-ipaq-driver
+++ a/drivers/usb/serial/ipaq.c
@@ -92,7 +92,6 @@ static void ipaq_destroy_lists(struct us
 
 static struct usb_device_id ipaq_id_table [] = {
 	/* The first entry is a placeholder for the insmod-specified device */
-	{ USB_DEVICE(0x049F, 0x0003) },
 	{ USB_DEVICE(0x0104, 0x00BE) }, /* Socket USB Sync */
 	{ USB_DEVICE(0x03F0, 0x1016) }, /* HP USB Sync */
 	{ USB_DEVICE(0x03F0, 0x1116) }, /* HP USB Sync 1611 */
_

Patches currently in -mm which might be from ben.collins@ubuntu.com are

usb-remove-duplicate-ids-from-option-card-driver.patch
usb-remove-duplicate-id-in-ipaq-driver.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
