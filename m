From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-optionc-add-zte-ac8710-usb-modem-device.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:12:57 -0700
Message-ID: <200907272112.n6RLCvkw012682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbZG0VNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:13:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.p.huang@gmail.com, greg@kroah.com


The patch titled
     drivers/usb/serial/option.c: add ZTE AC8710 usb modem device
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-optionc-add-zte-ac8710-usb-modem-device.patch

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
Subject: drivers/usb/serial/option.c: add ZTE AC8710 usb modem device
From: Peng Huang <shawn.p.huang@gmail.com>

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/usb/serial/option.c~drivers-usb-serial-optionc-add-zte-ac8710-usb-modem-device drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~drivers-usb-serial-optionc-add-zte-ac8710-usb-modem-device
+++ a/drivers/usb/serial/option.c
@@ -302,6 +302,7 @@ static int  option_resume(struct usb_ser
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
+#define ZTE_PRODUCT_AC8710			0xfff1
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -569,6 +570,7 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH, 0xff, 0xff, 0xff) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
_

Patches currently in -mm which might be from shawn.p.huang@gmail.com are

drivers-usb-serial-optionc-add-zte-ac8710-usb-modem-device.patch

