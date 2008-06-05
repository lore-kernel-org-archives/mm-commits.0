From: akpm@linux-foundation.org
Subject: - usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:39 -0700
Message-ID: <200806051821.m55ILdBA023243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761150AbYFESWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fexpop@onlinehome.de, jeff@garzik.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     USB ID for Philips CPWUA054/00 Wireless USB Adapter 11g
has been removed from the -mm tree.  Its filename was
     usb-id-for-philips-cpwua054-00-wireless-usb-adapter-11g.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


