From: akpm@linux-foundation.org
Subject: - another-id-for-cp2101-driver.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:25 -0800
Message-ID: <200702180215.l1I2FPsE008388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993115AbXBRCPb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pozsy@uhulinux.hu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     another id for cp2101 driver
has been removed from the -mm tree.  Its filename was
     another-id-for-cp2101-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: another id for cp2101 driver
From: Pozsar Balazs <pozsy@uhulinux.hu>

This patch adds another usb id to the cp2101. It seems to work well.

Signed-off-by: Pozsar Balazs <pozsy@uhulinux.hu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cp2101.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/serial/cp2101.c~another-id-for-cp2101-driver drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~another-id-for-cp2101-driver
+++ a/drivers/usb/serial/cp2101.c
@@ -69,6 +69,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
+	{ USB_DEVICE(0x10C5, 0xEA61) }, /* Silicon Labs MobiData GPRS USB Modem */
 	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
 	{ USB_DEVICE(0x16D6, 0x0001) }, /* Jablotron serial interface */
 	{ } /* Terminating Entry */
_

Patches currently in -mm which might be from pozsy@uhulinux.hu are
