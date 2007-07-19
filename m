From: akpm@linux-foundation.org
Subject: + usb-typo-in-usb-r8a66597-hcd-config.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:46:36 -0700
Message-ID: <200707190246.l6J2kafn009975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757176AbXGSCqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: M4rkusXXL@web.de, greg@kroah.com


The patch titled
     usb: typo in usb R8A66597 HCD config
has been added to the -mm tree.  Its filename is
     usb-typo-in-usb-r8a66597-hcd-config.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: typo in usb R8A66597 HCD config
From: M4rkusXXL <M4rkusXXL@web.de>

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/Kconfig~usb-typo-in-usb-r8a66597-hcd-config drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~usb-typo-in-usb-r8a66597-hcd-config
+++ a/drivers/usb/host/Kconfig
@@ -250,7 +250,7 @@ config USB_SL811_CS
 	  module will be called "sl811_cs".
 
 config USB_R8A66597_HCD
-	tristate "R8A66597 HCD suppoort"
+	tristate "R8A66597 HCD support"
 	depends on USB
 	help
 	  The R8A66597 is a USB 2.0 host and peripheral controller.
_

Patches currently in -mm which might be from M4rkusXXL@web.de are

usb-typo-in-usb-r8a66597-hcd-config.patch
