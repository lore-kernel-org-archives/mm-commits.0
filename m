From: akpm@linux-foundation.org
Subject: - usb-asix-add-buffalo-lua-u2-gt-10-100-1000.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:33 -0700
Message-ID: <200805092146.m49LkXuG027122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429AbYEIVrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, dhollis@davehollis.com, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     usb/asix: add Buffalo LUA-U2-GT 10/100/1000
has been removed from the -mm tree.  Its filename was
     usb-asix-add-buffalo-lua-u2-gt-10-100-1000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/asix: add Buffalo LUA-U2-GT 10/100/1000
From: Mattia Dongili <malattia@linux.it>

The USB net adapter Buffalo LUA-U2-GT (0411:006e) carries a AX88178 chip. 
Tested on the above HW.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Acked-off-by: David Hollis <dhollis@davehollis.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/usb/asix.c~usb-asix-add-buffalo-lua-u2-gt-10-100-1000 drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c~usb-asix-add-buffalo-lua-u2-gt-10-100-1000
+++ a/drivers/net/usb/asix.c
@@ -1381,6 +1381,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x0411, 0x003d),
 	.driver_info =  (unsigned long) &ax8817x_info,
 }, {
+	// Buffalo LUA-U2-GT 10/100/1000
+	USB_DEVICE (0x0411, 0x006e),
+	.driver_info =  (unsigned long) &ax88178_info,
+}, {
 	// Sitecom LN-029 "USB 2.0 10/100 Ethernet adapter"
 	USB_DEVICE (0x6189, 0x182d),
 	.driver_info =  (unsigned long) &ax8817x_info,
_

Patches currently in -mm which might be from malattia@linux.it are

origin.patch

