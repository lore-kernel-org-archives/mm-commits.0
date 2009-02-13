From: akpm@linux-foundation.org
Subject: [merged] usb-kill-prehistorical-comments-about-usb_ehci_hcd.patch removed from -mm tree
Date: Fri, 13 Feb 2009 11:56:03 -0800
Message-ID: <200902131956.n1DJu3rB028301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbZBMT4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 14:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tvignaud@mandriva.com, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: kill prehistorical comments about USB_EHCI_HCD
has been removed from the -mm tree.  Its filename was
     usb-kill-prehistorical-comments-about-usb_ehci_hcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: kill prehistorical comments about USB_EHCI_HCD
From: Thierry Vignaud <tvignaud@mandriva.com>

Remove old comments about USB_EHCI_HCD.

Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/usb/host/Kconfig~usb-kill-prehistorical-comments-about-usb_ehci_hcd drivers/usb/host/Kconfig
--- a/drivers/usb/host/Kconfig~usb-kill-prehistorical-comments-about-usb_ehci_hcd
+++ a/drivers/usb/host/Kconfig
@@ -24,10 +24,7 @@ config USB_EHCI_HCD
 	  The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
 	  "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
 	  If your USB host controller supports USB 2.0, you will likely want to
-	  configure this Host Controller Driver.  At the time of this writing, 
-	  the primary implementation of EHCI is a chip from NEC, widely available
-	  in add-on PCI cards, but implementations are in the works from other 
-	  vendors including Intel and Philips.  Motherboard support is appearing.
+	  configure this Host Controller Driver.
 
 	  EHCI controllers are packaged with "companion" host controllers (OHCI
 	  or UHCI) to handle USB 1.1 devices connected to root hub ports.  Ports
_

Patches currently in -mm which might be from tvignaud@mandriva.com are

linux-next.patch

