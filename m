From: akpm@linux-foundation.org
Subject: + btusb-patch-add_apple_macbookpro62.patch added to -mm tree
Date: Wed, 19 May 2010 12:06:46 -0700
Message-ID: <201005191906.o4JJ6ktf030453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab0ESTGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 15:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: froemel@vmars.tuwien.ac.at, marcel@holtmann.org


The patch titled
     drivers/bluetooth/btusb.c: add_apple_MacBookPro62
has been added to the -mm tree.  Its filename is
     btusb-patch-add_apple_macbookpro62.patch

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
Subject: drivers/bluetooth/btusb.c: add_apple_MacBookPro62
From: Bernhard Froemel <froemel@vmars.tuwien.ac.at>

The Apple MBP model 6.2 (and maybe other recent MBPs) uses an Apple
branded BCM2046 USB bluetooth device that works well [1] with your generic
driver.  Ass the vendor and device id.

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/btusb.c~btusb-patch-add_apple_macbookpro62 drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c~btusb-patch-add_apple_macbookpro62
+++ a/drivers/bluetooth/btusb.c
@@ -75,6 +75,9 @@ static struct usb_device_id btusb_table[
 	/* Canyon CN-BTU1 with HID interfaces */
 	{ USB_DEVICE(0x0c10, 0x0000) },
 
+	/* Apple MacBookPro6 BT device */
+	{ USB_DEVICE(0x05ac, 0x8218) },
+
 	{ }	/* Terminating entry */
 };
 
_

Patches currently in -mm which might be from froemel@vmars.tuwien.ac.at are

linux-next.patch
btusb-patch-add_apple_macbookpro62.patch

