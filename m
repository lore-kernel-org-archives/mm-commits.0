From: akpm@linux-foundation.org
Subject: - bluetooth-blacklist-another-broadcom-bcm2035-device.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:47 -0800
Message-ID: <200802052239.m15MdSGO013061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760429AbYBEWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy@smile.org.ua, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     bluetooth: blacklist another Broadcom BCM2035 device
has been removed from the -mm tree.  Its filename was
     bluetooth-blacklist-another-broadcom-bcm2035-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: blacklist another Broadcom BCM2035 device
From: Andy Shevchenko <andy@smile.org.ua>

This device is recognized as bluetooth, but still not works.

Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/hci_usb.c~bluetooth-blacklist-another-broadcom-bcm2035-device drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~bluetooth-blacklist-another-broadcom-bcm2035-device
+++ a/drivers/bluetooth/hci_usb.c
@@ -111,6 +111,7 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x0a5c, 0x2033), .driver_info = HCI_IGNORE },
 
 	/* Broadcom BCM2035 */
+	{ USB_DEVICE(0x0a5c, 0x2035), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x200a), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
 
_

Patches currently in -mm which might be from andy@smile.org.ua are

origin.patch
usb-yet-another-dell-wireless-cdma-evdo-modem.patch
