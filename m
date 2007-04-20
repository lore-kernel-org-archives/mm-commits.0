From: akpm@linux-foundation.org
Subject: + remove-duplicate-define-of-ohci_quirk_zfmicro.patch added to -mm tree
Date: Fri, 20 Apr 2007 13:26:37 -0700
Message-ID: <200704202026.l3KKQb6b023123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031025AbXDTU12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 16:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, greg@kroah.com, tony.olech@elandigitalsystems.com


The patch titled
     Remove duplicate define of OHCI_QUIRK_ZFMICRO
has been added to the -mm tree.  Its filename is
     remove-duplicate-define-of-ohci_quirk_zfmicro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

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

remove-duplicate-define-of-ohci_quirk_zfmicro.patch
