From: akpm@linux-foundation.org
Subject: + usb-serial-add-support-for-second-revision-of-ericsson-f3507g-wwan-card.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:38:53 -0800
Message-ID: <200902242138.n1OLcr0l013079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbZBXVi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:38:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: patrik@yes.nu, greg@kroah.com


The patch titled
     usb-serial: add support for second revision of Ericsson F3507G WWAN card
has been added to the -mm tree.  Its filename is
     usb-serial-add-support-for-second-revision-of-ericsson-f3507g-wwan-card.patch

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
Subject: usb-serial: add support for second revision of Ericsson F3507G WWAN card
From: Patrik Kullman <patrik@yes.nu>

I noticed that my revision of the F3507G WWAN card isn't listed in
drivers/usb/serial/option.c

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/option.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/usb/serial/option.c~usb-serial-add-support-for-second-revision-of-ericsson-f3507g-wwan-card drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~usb-serial-add-support-for-second-revision-of-ericsson-f3507g-wwan-card
+++ a/drivers/usb/serial/option.c
@@ -296,7 +296,8 @@ static int  option_resume(struct usb_ser
 
 /* Ericsson products */
 #define ERICSSON_VENDOR_ID			0x0bdb
-#define ERICSSON_PRODUCT_F3507G			0x1900
+#define ERICSSON_PRODUCT_F3507G_1		0x1900
+#define ERICSSON_PRODUCT_F3507G_2		0x1902
 
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
@@ -511,7 +512,8 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
-	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G) },
+	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G_1) },
+	{ USB_DEVICE(ERICSSON_VENDOR_ID, ERICSSON_PRODUCT_F3507G_2) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
_

Patches currently in -mm which might be from patrik@yes.nu are

usb-serial-add-support-for-second-revision-of-ericsson-f3507g-wwan-card.patch

