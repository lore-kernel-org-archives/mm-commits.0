From: akpm@osdl.org
Subject: + usb-serial-add-support-for-novatel-s720-u720-cdma-ev-do.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:27:57 -0800
Message-ID: <200612101927.kBAJRvZf000824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762381AbWLJT2D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:28:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric@brouhaha.com, greg@kroah.com


The patch titled
     usb serial: add support for Novatel S720/U720 CDMA/EV-DO modems
has been added to the -mm tree.  Its filename is
     usb-serial-add-support-for-novatel-s720-u720-cdma-ev-do.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb serial: add support for Novatel S720/U720 CDMA/EV-DO modems
From: "Eric Smith" <eric@brouhaha.com>

Add USB vendor/device IDs for Novatel Wireless S720 and U720 CDMA/EV-DO
modems to airprime.c.

Signed-off-by: Eric Smith <eric@brouhaha.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/serial/airprime.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/usb/serial/airprime.c~usb-serial-add-support-for-novatel-s720-u720-cdma-ev-do drivers/usb/serial/airprime.c
--- a/drivers/usb/serial/airprime.c~usb-serial-add-support-for-novatel-s720-u720-cdma-ev-do
+++ a/drivers/usb/serial/airprime.c
@@ -19,6 +19,8 @@
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0c88, 0x17da) }, /* Kyocera Wireless KPC650/Passport */
 	{ USB_DEVICE(0x1410, 0x1110) }, /* Novatel Wireless Merlin CDMA */
+	{ USB_DEVICE(0x1410, 0x1130) }, /* Novatel Wireless S720 CDMA/EV-DO */
+	{ USB_DEVICE(0x1410, 0x2110) }, /* Novatel Wireless U720 CDMA/EV-DO */
 	{ USB_DEVICE(0x1410, 0x1430) },	/* Novatel Merlin XU870 HSDPA/3G */
 	{ USB_DEVICE(0x1410, 0x1100) }, /* ExpressCard34 Qualcomm 3G CDMA */
 	{ USB_DEVICE(0x413c, 0x8115) }, /* Dell Wireless HSDPA 5500 */
_

Patches currently in -mm which might be from eric@brouhaha.com are

usb-serial-add-support-for-novatel-s720-u720-cdma-ev-do.patch

