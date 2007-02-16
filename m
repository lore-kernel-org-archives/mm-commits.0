From: akpm@linux-foundation.org
Subject: + another-id-for-cp2101-driver.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:16:39 -0800
Message-ID: <200702162116.l1GLGdD4010066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946239AbXBPVQo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pozsy@uhulinux.hu, greg@kroah.com


The patch titled
     another id for cp2101 driver
has been added to the -mm tree.  Its filename is
     another-id-for-cp2101-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

another-id-for-cp2101-driver.patch
