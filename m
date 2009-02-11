From: akpm@linux-foundation.org
Subject: [merged] radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:59:15 -0800
Message-ID: <200902112159.n1BLxFuo011405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbZBKWIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, greg@kroah.com, mlord@pobox.com, tobias.lorenz@gmx.net, mm-commits@vger.kernel.org


The patch titled
     radio-si470x: add USB ID for dealextreme usb radio
has been removed from the -mm tree.  Its filename was
     radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radio-si470x: add USB ID for dealextreme usb radio
From: Mark Lord <lkml@rtr.ca>

Add USB ID for the Sil4701 radio from DealExtreme.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-si470x.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/media/radio/radio-si470x.c~radio-si470x-add-usb-id-for-dealextreme-usb-radio drivers/media/radio/radio-si470x.c
--- a/drivers/media/radio/radio-si470x.c~radio-si470x-add-usb-id-for-dealextreme-usb-radio
+++ a/drivers/media/radio/radio-si470x.c
@@ -136,6 +136,8 @@
 static struct usb_device_id si470x_usb_driver_id_table[] = {
 	/* Silicon Labs USB FM Radio Reference Design */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
+	/* DealExtreme USB Radio */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c5, 0x819a,	USB_CLASS_HID, 0, 0) },
 	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x06e1, 0xa155, USB_CLASS_HID, 0, 0) },
 	/* KWorld USB FM Radio SnapMusic Mobile 700 (FM700) */
_

Patches currently in -mm which might be from lkml@rtr.ca are

radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch
ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch

