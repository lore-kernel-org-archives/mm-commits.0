From: akpm@linux-foundation.org
Subject: - hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops.patch removed from -mm tree
Date: Fri, 25 May 2007 09:43:39 -0700
Message-ID: <200705251643.l4PGhdjO022943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760173AbXEYQoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 May 2007 12:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcollins@ubuntu.com, marcel@holtmann.org, maxk@qualcomm.com, phillip@ubuntu.com, tim.gardner@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     HCIUSB: Initialize the Broadcom USB Bluetooth device in Dell laptops
has been removed from the -mm tree.  Its filename was
     hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: HCIUSB: Initialize the Broadcom USB Bluetooth device in Dell laptops
From: Ben Collins <bcollins@ubuntu.com>

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Signed-off-by: Phillip lougher <phillip@ubuntu.com>
Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_usb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/bluetooth/hci_usb.c~hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops drivers/bluetooth/hci_usb.c
--- a/drivers/bluetooth/hci_usb.c~hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops
+++ a/drivers/bluetooth/hci_usb.c
@@ -131,7 +131,7 @@ static struct usb_device_id blacklist_id
 	{ USB_DEVICE(0x03f0, 0x171d), .driver_info = HCI_WRONG_SCO_MTU },
 
 	/* Dell laptop with Broadcom chip */
-	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU },
+	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU|HCI_RESET },
 
 	/* Microsoft Wireless Transceiver for Bluetooth 2.0 */
 	{ USB_DEVICE(0x045e, 0x009c), .driver_info = HCI_RESET },
_

Patches currently in -mm which might be from bcollins@ubuntu.com are

origin.patch
avoid-zero-size-allocation-in-cache_k8_northbridges.patch
hciusb-initialize-the-broadcom-usb-bluetooth-device-in-dell-laptops.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
rtc-ratelimit-lost-interrupts-message.patch
