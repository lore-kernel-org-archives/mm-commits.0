From: akpm@linux-foundation.org
Subject: - usb-serial-cp2101-add-enfora-gsm2228.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:59 -0800
Message-ID: <200811132128.mADLRxGO028229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbYKMV2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damir@mimas.ru, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial: cp2101: add Enfora GSM2228
has been removed from the -mm tree.  Its filename was
     usb-serial-cp2101-add-enfora-gsm2228.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-serial: cp2101: add Enfora GSM2228
From: Damir N Abdullin <damir@mimas.ru <mailto:damir@mimas.ru>>

Enfora GSM2228 based on Cygnal Integrated Products chip uses the same
cp2101 driver.

Signed-off-by: Damir N Abdullin <damir@mimas.ru <mailto:damir@mimas.ru>>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cp2101.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/serial/cp2101.c~usb-serial-cp2101-add-enfora-gsm2228 drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~usb-serial-cp2101-add-enfora-gsm2228
+++ a/drivers/usb/serial/cp2101.c
@@ -67,6 +67,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x10C4, 0x800A) }, /* SPORTident BSM7-D-USB main station */
 	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
 	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
+	{ USB_DEVICE(0x10C4, 0x8054) }, /* Enfora GSM2228 */
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
_

Patches currently in -mm which might be from damir@mimas.ru are

linux-next.patch

