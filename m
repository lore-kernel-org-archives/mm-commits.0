From: akpm@linux-foundation.org
Subject: - usb-typo-in-usb-r8a66597-hcd-config.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:13:40 -0700
Message-ID: <200708201913.l7KJDeJW018463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbXHTTVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: M4rkusXXL@web.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: typo in usb R8A66597 HCD config
has been removed from the -mm tree.  Its filename was
     usb-typo-in-usb-r8a66597-hcd-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: typo in usb R8A66597 HCD config
From: M4rkusXXL <M4rkusXXL@web.de>

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/Kconfig~usb-typo-in-usb-r8a66597-hcd-config drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~usb-typo-in-usb-r8a66597-hcd-config
+++ a/drivers/usb/host/Kconfig
@@ -237,7 +237,7 @@ config USB_SL811_CS
 	  module will be called "sl811_cs".
 
 config USB_R8A66597_HCD
-	tristate "R8A66597 HCD suppoort"
+	tristate "R8A66597 HCD support"
 	depends on USB
 	help
 	  The R8A66597 is a USB 2.0 host and peripheral controller.
_

Patches currently in -mm which might be from M4rkusXXL@web.de are
