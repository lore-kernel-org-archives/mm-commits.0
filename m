From: akpm@linux-foundation.org
Subject: + drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:37:26 -0800
Message-ID: <201002012037.o11KbQM6010940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab0BAUhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:37:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mail@mcbeister.de, akpm@linux-foundation.org, marcel@holtmann.org


The patch titled
     drivers/bluetooth/btusb.c: add "TDK Corp. Integrated Bluetooth" support
has been added to the -mm tree.  Its filename is
     drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch

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
Subject: drivers/bluetooth/btusb.c: add "TDK Corp. Integrated Bluetooth" support
From: Marcel Beister <mail@mcbeister.de>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=15172

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/bluetooth/btusb.c~drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c~drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support
+++ a/drivers/bluetooth/btusb.c
@@ -65,6 +65,9 @@ static struct usb_device_id btusb_table[
 	/* Bluetooth Ultraport Module from IBM */
 	{ USB_DEVICE(0x04bf, 0x030a) },
 
+	/* TDK Corp. Integrated Bluetooth */
+	{ USB_DEVICE(0x04bf, 0x0310) },
+
 	/* ALPS Modules with non-standard id */
 	{ USB_DEVICE(0x044e, 0x3001) },
 	{ USB_DEVICE(0x044e, 0x3002) },
_

Patches currently in -mm which might be from mail@mcbeister.de are

drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch

