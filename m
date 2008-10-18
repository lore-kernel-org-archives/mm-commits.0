From: akpm@linux-foundation.org
Subject: - rtl8187-support-of-belkin-f5d7050rev5000de.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:07 -0700
Message-ID: <200810182321.m9INL7CK029905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbYJRXVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florent.fourcot@enst-bretagne.fr, Larry.Finger@lwfinger.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     rtl8187: support of Belkin "F5D7050rev5000de"
has been removed from the -mm tree.  Its filename was
     rtl8187-support-of-belkin-f5d7050rev5000de.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtl8187: support of Belkin "F5D7050rev5000de"
From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>

This Belkin product (id 050d:705e) use Realtek's RTL8187B and works fine
with the new 2.6.27 driver.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rtl8187_dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/net/wireless/rtl8187_dev.c~rtl8187-support-of-belkin-f5d7050rev5000de drivers/net/wireless/rtl8187_dev.c
--- a/drivers/net/wireless/rtl8187_dev.c~rtl8187-support-of-belkin-f5d7050rev5000de
+++ a/drivers/net/wireless/rtl8187_dev.c
@@ -33,6 +33,8 @@ MODULE_LICENSE("GPL");
 static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Asus */
 	{USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
+	/* Belkin */
+	{USB_DEVICE(0x050d, 0x705e), .driver_info = DEVICE_RTL8187B},
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
_

Patches currently in -mm which might be from florent.fourcot@enst-bretagne.fr are

origin.patch

