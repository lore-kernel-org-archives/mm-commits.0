From: akpm@linux-foundation.org
Subject: + drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch added to -mm tree
Date: Wed, 21 Apr 2010 11:02:41 -0700
Message-ID: <201004211802.o3LI2foj000571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab0DUSDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 14:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@ahash.de, davem@davemloft.net, oliver@neukum.org


The patch titled
     drivers/usb/net/kaweth.c: add device "Allied Telesyn AT-USB10 USB Ethernet Adapter"
has been added to the -mm tree.  Its filename is
     drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/usb/net/kaweth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/net/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter drivers/usb/net/kaweth.c
--- a/drivers/usb/net/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter
+++ a/drivers/usb/net/kaweth.c
@@ -146,6 +146,7 @@ static struct usb_device_id usb_klsi_tab
 	{ USB_DEVICE(0x0707, 0x0100) }, /* SMC 2202USB */
 	{ USB_DEVICE(0x07aa, 0x0001) }, /* Correga K.K. */
 	{ USB_DEVICE(0x07b8, 0x4000) }, /* D-Link DU-E10 */
+	{ USB_DEVICE(0x07c9, 0xb010) }, /* Allied Telesyn AT-USB10 USB Ethernet Adapter */
 	{ USB_DEVICE(0x0846, 0x1001) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x0846, 0x1002) }, /* NetGear EA-101 */
 	{ USB_DEVICE(0x085a, 0x0008) }, /* PortGear Ethernet Adapter */
_

Patches currently in -mm which might be from andi@ahash.de are

drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter.patch
kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch

