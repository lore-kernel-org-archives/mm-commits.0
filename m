From: akpm@linux-foundation.org
Subject: - usb-remove-airprime-device-from-optionc.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:23 -0800
Message-ID: <200702180215.l1I2FNMc008385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993112AbXBRCP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@sierrawireless.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: remove Airprime device from option.c
has been removed from the -mm tree.  Its filename was
     usb-remove-airprime-device-from-optionc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: remove Airprime device from option.c
From: Kevin Lloyd <linux@sierrawireless.com>

Remove the Airprime 5220 device (branded as Audiovox) from the option.c
driver.  This device is already supported by the sierra.c driver.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/usb/serial/option.c~usb-remove-airprime-device-from-optionc drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-remove-airprime-device-from-optionc
+++ a/drivers/usb/serial/option.c
@@ -69,7 +69,6 @@ static int  option_send_setup(struct usb
 /* Vendor and product IDs */
 #define OPTION_VENDOR_ID                0x0AF0
 #define HUAWEI_VENDOR_ID                0x12D1
-#define AUDIOVOX_VENDOR_ID              0x0F3D
 #define NOVATELWIRELESS_VENDOR_ID       0x1410
 #define ANYDATA_VENDOR_ID               0x16d5
 
@@ -81,7 +80,6 @@ static int  option_send_setup(struct usb
 #define OPTION_PRODUCT_GTMAX36          0x6701
 #define HUAWEI_PRODUCT_E600             0x1001
 #define HUAWEI_PRODUCT_E220             0x1003
-#define AUDIOVOX_PRODUCT_AIRCARD        0x0112
 #define NOVATELWIRELESS_PRODUCT_U740    0x1400
 #define ANYDATA_PRODUCT_ID              0x6501
 
@@ -94,7 +92,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTMAX36) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
 	{ } /* Terminating entry */
@@ -109,7 +106,6 @@ static struct usb_device_id option_ids1[
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_GTMAX36) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E600) },
 	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E220) },
-	{ USB_DEVICE(AUDIOVOX_VENDOR_ID, AUDIOVOX_PRODUCT_AIRCARD) },
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID,NOVATELWIRELESS_PRODUCT_U740) },
 	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ID) },
 	{ } /* Terminating entry */
_

Patches currently in -mm which might be from linux@sierrawireless.com are

origin.patch
