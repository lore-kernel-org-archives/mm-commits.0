From: akpm@linux-foundation.org
Subject: [merged] bluetooth-add-support-for-bcm20702a0.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:55 -0800
Message-ID: <20120308191755.ABCA2A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:62568 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab2CHTR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:56 -0500
Received: by yhgm50 with SMTP id m50so103498yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.leddy@canonical.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bluetooth: add support for BCM20702A0 [0a5c:21e6]
has been removed from the -mm tree.  Its filename was
     bluetooth-add-support-for-bcm20702a0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "James M. Leddy" <james.leddy@canonical.com>
Subject: bluetooth: add support for BCM20702A0 [0a5c:21e6]

Add another vendor specific ID for BCM20702A0.  This has been tested and
works on hardware with this device.

output of usb-devices:
T: Bus=01 Lev=02 Prnt=02 Port=03 Cnt=04 Dev#= 6 Spd=12 MxCh= 0
D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
P: Vendor=0a5c ProdID=21e6 Rev=01.12
S: Manufacturer=Broadcom Corp
S: Product=BCM20702A0
S: SerialNumber=D0DF9AFB227B
C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: James M. Leddy <james.leddy@canonical.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/bluetooth/btusb.c~bluetooth-add-support-for-bcm20702a0 drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c~bluetooth-add-support-for-bcm20702a0
+++ a/drivers/bluetooth/btusb.c
@@ -102,6 +102,7 @@ static struct usb_device_id btusb_table[
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0a5c, 0x21e3) },
+	{ USB_DEVICE(0x0a5c, 0x21e6) },
 	{ USB_DEVICE(0x0a5c, 0x21f3) },
 	{ USB_DEVICE(0x413c, 0x8197) },
 
_

Patches currently in -mm which might be from james.leddy@canonical.com are

linux-next.patch

