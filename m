From: akpm@linux-foundation.org
Subject: + usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g.patch added to -mm tree
Date: Thu, 29 May 2008 00:36:45 -0700
Message-ID: <200805290736.m4T7ajef022811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbYE2Hhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 03:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fexpop@onlinehome.de, jeff@garzik.org, linville@tuxdriver.com


The patch titled
     USB ID for Philips CPWUA054/00 Wireless USB Adapter 11g
has been added to the -mm tree.  Its filename is
     usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: USB ID for Philips CPWUA054/00 Wireless USB Adapter 11g
From: Felix Homann <fexpop@onlinehome.de>

Enable the Philips CPWUA054/00 in p54usb.

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/p54/p54usb.c~usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c~usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g
+++ a/drivers/net/wireless/p54/p54usb.c
@@ -49,6 +49,7 @@ static struct usb_device_id p54u_table[]
 	{USB_DEVICE(0x5041, 0x2235)},	/* Linksys WUSB54G Portable */
 
 	/* Version 2 devices (3887) */
+	{USB_DEVICE(0x0471, 0x1230)},   /* Philips CPWUA054/00 */
 	{USB_DEVICE(0x050d, 0x7050)},	/* Belkin F5D7050 ver 1000 */
 	{USB_DEVICE(0x0572, 0x2000)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0572, 0x2002)},	/* Cohiba Proto board */
_

Patches currently in -mm which might be from fexpop@onlinehome.de are

usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g.patch

