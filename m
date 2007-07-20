From: akpm@linux-foundation.org
Subject: + usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:21:33 -0700
Message-ID: <200707200021.l6K0LX9f030452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735AbXGTAVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juergen@kreuzholzen.de, greg@kroah.com


The patch titled
     USB devices misc: build the IOWARRIOR when it is selected in Kconfig
has been added to the -mm tree.  Its filename is
     usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usb-devices-misc-build-the-iowarrior-when-it-is-selected-in-kconfig.patch
geode-setup-correct-chipset-access-functions.patch
