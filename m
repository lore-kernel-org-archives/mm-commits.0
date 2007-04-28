From: akpm@linux-foundation.org
Subject: - remove-duplicate-define-of-ohci_quirk_zfmicro.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:54:47 -0700
Message-ID: <200704281054.l3SAsl2C020143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965748AbXD1Kz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: caglar@pardus.org.tr, greg@kroah.com, tony.olech@elandigitalsystems.com, mm-commits@vger.kernel.org


The patch titled
     Remove duplicate define of OHCI_QUIRK_ZFMICRO
has been removed from the -mm tree.  Its filename was
     remove-duplicate-define-of-ohci_quirk_zfmicro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove duplicate define of OHCI_QUIRK_ZFMICRO
From: "S.Caglar Onur" <caglar@pardus.org.tr>

Remove duplicate define of OHCI_QUIRK_ZFMICRO from ftdi-elan.c, its already
defined in drivers/ush/host/ohci.c

Signed-off-by: "S.Caglar Onur" <caglar@pardus.org.tr>
Cc: <tony.olech@elandigitalsystems.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/ftdi-elan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/usb/misc/ftdi-elan.c~remove-duplicate-define-of-ohci_quirk_zfmicro drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~remove-duplicate-define-of-ohci_quirk_zfmicro
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -2304,7 +2304,6 @@ static int ftdi_elan_checkingPCI(struct 
 #define OHCI_QUIRK_SUPERIO 0x02
 #define OHCI_QUIRK_INITRESET 0x04
 #define OHCI_BIG_ENDIAN 0x08
-#define OHCI_QUIRK_ZFMICRO 0x10
 #define OHCI_CONTROL_INIT OHCI_CTRL_CBSR
 #define OHCI_INTR_INIT (OHCI_INTR_MIE | OHCI_INTR_UE | OHCI_INTR_RD | \
         OHCI_INTR_WDH)
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

origin.patch
