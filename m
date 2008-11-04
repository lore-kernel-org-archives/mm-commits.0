From: akpm@linux-foundation.org
Subject: + sisusb2vga-driver-add-0x0711-0x0903.patch added to -mm tree
Date: Tue, 04 Nov 2008 10:44:01 -0800
Message-ID: <200811041844.mA4Ii14X028631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYKDSoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 13:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert@ecm.ub.es, alan@lxorguk.ukuu.org.uk, albert.comerma@gmail.com, david-b@pacbell.net, greg@kroah.com, mchehab@infradead.org


The patch titled
     SISUSB2VGA driver: add 0x0711, 0x0903
has been added to the -mm tree.  Its filename is
     sisusb2vga-driver-add-0x0711-0x0903.patch

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
Subject: SISUSB2VGA driver: add 0x0711, 0x0903
From: Albert Comerma <albert@ecm.ub.es>

Signed-off-by: Albert Comerma <albert.comerma@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/misc/sisusbvga/sisusb.c~sisusb2vga-driver-add-0x0711-0x0903 drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~sisusb2vga-driver-add-0x0711-0x0903
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3270,6 +3270,7 @@ static struct usb_device_id sisusb_table
 	{ USB_DEVICE(0x0711, 0x0900) },
 	{ USB_DEVICE(0x0711, 0x0901) },
 	{ USB_DEVICE(0x0711, 0x0902) },
+	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
_

Patches currently in -mm which might be from albert@ecm.ub.es are

sisusb2vga-driver-add-0x0711-0x0903.patch

