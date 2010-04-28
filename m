From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:03:15 -0400
Message-ID: <201004281804.o3SI4m0V010983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab0D1SFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@ahash.de, davem@davemloft.net, oliver@neukum.org, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/net/kaweth.c: add device "Allied Telesyn AT-USB10 USB Ethernet Adapter"
has been removed from the -mm tree.  Its filename was
     drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/net/kaweth.c: add device "Allied Telesyn AT-USB10 USB Ethernet Adapter"
From: Andreas Hartmann <andi@ahash.de>

akpm: reluctantly typed in from
https://bugzilla.kernel.org/show_bug.cgi?id=15599

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/kaweth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/usb/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter
+++ a/drivers/net/usb/kaweth.c
@@ -145,6 +145,7 @@ static struct usb_device_id usb_klsi_tab
 	{ USB_DEVICE(0x0707, 0x0100) }, /* SMC 2202USB */
 	{ USB_DEVICE(0x07aa, 0x0001) }, /* Correga K.K. */
 	{ USB_DEVICE(0x07b8, 0x4000) }, /* D-Link DU-E10 */
+	{ USB_DEVICE(0x07c9, 0xb010) }, /* Allied Telesyn AT-USB10 USB Ethernet Adapter */
 	{ USB_DEVICE(0x0846, 0x1001) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x0846, 0x1002) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x085a, 0x0008) }, /* PortGear Ethernet Adapter */
_

Patches currently in -mm which might be from andi@ahash.de are

linux-next.patch

