From: akpm@linux-foundation.org
Subject: [merged] usb-add-missing-class-descriptions-used-in-usb-devices-file.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:14 -0700
Message-ID: <200907142033.n6EKXEGV013182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510AbZGNUdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: add missing class descriptions used in usb/devices file
has been removed from the -mm tree.  Its filename was
     usb-add-missing-class-descriptions-used-in-usb-devices-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: add missing class descriptions used in usb/devices file
From: Frans Pop <elendil@planet.nl>

Added descriptions (for WIRELESS_CONTROLLER and MISC) were taken from
the usb-devices script now included in usbutils.

Also sort the classes in the same order as in include/linux/usb/ch9.h
for easier comparison for future updates.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/devices.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/usb/core/devices.c~usb-add-missing-class-descriptions-used-in-usb-devices-file drivers/usb/core/devices.c
--- a/drivers/usb/core/devices.c~usb-add-missing-class-descriptions-used-in-usb-devices-file
+++ a/drivers/usb/core/devices.c
@@ -136,17 +136,19 @@ static const struct class_info clas_info
 	{USB_CLASS_AUDIO,		"audio"},
 	{USB_CLASS_COMM,		"comm."},
 	{USB_CLASS_HID,			"HID"},
-	{USB_CLASS_HUB,			"hub"},
 	{USB_CLASS_PHYSICAL,		"PID"},
+	{USB_CLASS_STILL_IMAGE,		"still"},
 	{USB_CLASS_PRINTER,		"print"},
 	{USB_CLASS_MASS_STORAGE,	"stor."},
+	{USB_CLASS_HUB,			"hub"},
 	{USB_CLASS_CDC_DATA,		"data"},
-	{USB_CLASS_APP_SPEC,		"app."},
-	{USB_CLASS_VENDOR_SPEC,		"vend."},
-	{USB_CLASS_STILL_IMAGE,		"still"},
 	{USB_CLASS_CSCID,		"scard"},
 	{USB_CLASS_CONTENT_SEC,		"c-sec"},
 	{USB_CLASS_VIDEO,		"video"},
+	{USB_CLASS_WIRELESS_CONTROLLER,	"wlcon"},
+	{USB_CLASS_MISC,		"misc"},
+	{USB_CLASS_APP_SPEC,		"app."},
+	{USB_CLASS_VENDOR_SPEC,		"vend."},
 	{-1,				"unk."}		/* leave as last */
 };
 
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch

