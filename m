From: akpm@linux-foundation.org
Subject: [merged] at76_usb-add-support-for-oqo-model-01.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:04 -0800
Message-ID: <200902092005.n19K548c023920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbZBIUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jm@lentin.co.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     at76_usb: add support for OQO Model 01+
has been removed from the -mm tree.  Its filename was
     at76_usb-add-support-for-oqo-model-01.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at76_usb: add support for OQO Model 01+
From: Jamie Lentin <jm@lentin.co.uk>

Add USB device ID for OQO 01+'s internal wireless LAN

An OQO employee mentions the chip's true identity here:-

   ftp://ftp.oqo.com/unsupported/linux/OQOLinux.html

Works fine with the current staging driver.  I see there's a mac80211 port
in the works which I haven't tried, but more than happy to help test if
required.

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/at76_usb/at76_usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/staging/at76_usb/at76_usb.c~at76_usb-add-support-for-oqo-model-01 drivers/staging/at76_usb/at76_usb.c
--- a/drivers/staging/at76_usb/at76_usb.c~at76_usb-add-support-for-oqo-model-01
+++ a/drivers/staging/at76_usb/at76_usb.c
@@ -231,6 +231,8 @@ static struct usb_device_id dev_table[] 
 	{USB_DEVICE(0x03eb, 0x7617), USB_DEVICE_DATA(BOARD_505A)},
 	/* Siemens Gigaset USB WLAN Adapter 11 */
 	{USB_DEVICE(0x1690, 0x0701), USB_DEVICE_DATA(BOARD_505A)},
+	/* OQO Model 01+ Internal Wi-Fi */
+	{USB_DEVICE(0x1557, 0x0002), USB_DEVICE_DATA(BOARD_505A)},
 	/*
 	 * at76c505amx-rfmd
 	 */
_

Patches currently in -mm which might be from jm@lentin.co.uk are

linux-next.patch

