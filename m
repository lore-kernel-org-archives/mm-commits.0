From: akpm@linux-foundation.org
Subject: [nacked] drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch removed from -mm tree
Date: Wed, 03 Feb 2010 15:48:55 -0800
Message-ID: <201002032348.o13Nmthc027034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659Ab0BCXtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:49:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mail@mcbeister.de, akpm@linux-foundation.org, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     drivers/bluetooth/btusb.c: add "TDK Corp. Integrated Bluetooth" support
has been removed from the -mm tree.  Its filename was
     drivers-bluetooth-btusbc-add-tdk-corp-integrated-bluetooth-support.patch

This patch was dropped because it was nacked

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

