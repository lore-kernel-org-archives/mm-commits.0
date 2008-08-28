From: akpm@linux-foundation.org
Subject: - correct-sierra-wireless-usb-evdo-modem-device-id.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:49:23 -0700
Message-ID: <200808282149.m7SLnNdW016184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbYH1Vt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: murraytony@gmail.com, greg@kroah.com, klloyd@sierrawireless.com, mm-commits@vger.kernel.org


The patch titled
     usb: correct Sierra Wireless USB EVDO Modem Device ID
has been removed from the -mm tree.  Its filename was
     correct-sierra-wireless-usb-evdo-modem-device-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: correct Sierra Wireless USB EVDO Modem Device ID
From: "Tony Murray" <murraytony@gmail.com>

I was trying to figure out why my device wasn't supported by the
drivers/usb/serial/sierra.c driver, while looking throught the device
IDs I spotted what I believe to be a typo in the device IDs.

Cc: <klloyd@sierrawireless.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/sierra.c~correct-sierra-wireless-usb-evdo-modem-device-id drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~correct-sierra-wireless-usb-evdo-modem-device-id
+++ a/drivers/usb/serial/sierra.c
@@ -163,7 +163,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x03f0, 0x1b1d) }, /* HP ev2200 a.k.a MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0024) },	/* Sierra Wireless MC5727 */
 	{ USB_DEVICE(0x1199, 0x0220) },	/* Sierra Wireless MC5725 */
_

Patches currently in -mm which might be from murraytony@gmail.com are

linux-next.patch

