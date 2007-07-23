From: akpm@linux-foundation.org
Subject: - usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:42 -0700
Message-ID: <200707230935.l6N9ZgJh016512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758378AbXGWJpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juergen@kreuzholzen.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB devices misc: build the IOWARRIOR when it is selected in Kconfig
has been removed from the -mm tree.  Its filename was
     usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB devices misc: build the IOWARRIOR when it is selected in Kconfig
From: Juergen Beisert <juergen@kreuzholzen.de>

Signed-off-by: Juergen Beisert <juergen@kreuzholzen.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/Makefile |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/usb/Makefile~usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig drivers/usb/Makefile
--- a/drivers/usb/Makefile~usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig
+++ a/drivers/usb/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_USB_SISUSBVGA)	+= misc/
 obj-$(CONFIG_USB_TEST)		+= misc/
 obj-$(CONFIG_USB_TRANCEVIBRATOR)+= misc/
 obj-$(CONFIG_USB_USS720)	+= misc/
+obj-$(CONFIG_USB_IOWARRIOR)	+= misc/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
 obj-$(CONFIG_USB_SPEEDTOUCH)	+= atm/
_

Patches currently in -mm which might be from juergen@kreuzholzen.de are
