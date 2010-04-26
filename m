From: akpm@linux-foundation.org
Subject: [merged] kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:27:13 -0400
Message-ID: <201004261728.o3QHSlL6009135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997Ab0DZR3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@ahash.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kaweth: new USB ID 07c9:b010 Allied Telesyn AT-USB10
has been removed from the -mm tree.  Its filename was
     kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kaweth: new USB ID 07c9:b010 Allied Telesyn AT-USB10
From: Andreas Hartmann <andi@ahash.de>

New USB ID 07c9:b010 Allied Telesyn AT-USB10.

Signed-off-by: Andreas Hartmann <andi@ahash.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/kaweth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/usb/kaweth.c~kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10 drivers/net/usb/kaweth.c
--- a/drivers/net/usb/kaweth.c~kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10
+++ a/drivers/net/usb/kaweth.c
@@ -145,6 +145,7 @@ static struct usb_device_id usb_klsi_tab
 	{ USB_DEVICE(0x0707, 0x0100) }, /* SMC 2202USB */
 	{ USB_DEVICE(0x07aa, 0x0001) }, /* Correga K.K. */
 	{ USB_DEVICE(0x07b8, 0x4000) }, /* D-Link DU-E10 */
+	{ USB_DEVICE(0x07c9, 0xb010) }, /* Allied Telesyn AT-USB10 */
 	{ USB_DEVICE(0x0846, 0x1001) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x0846, 0x1002) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x085a, 0x0008) }, /* PortGear Ethernet Adapter */
_

Patches currently in -mm which might be from andi@ahash.de are

drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch

