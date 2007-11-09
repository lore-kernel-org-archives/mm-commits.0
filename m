From: akpm@linux-foundation.org
Subject: + i386-reboot-fixup-for-wrap-2c-board-sc1100-based.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:33:13 -0800
Message-ID: <200711090433.lA94XEDJ029419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIEdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: denys@visp.net.lb, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386: reboot fixup for WRAP 2C board (SC1100 based)
has been added to the -mm tree.  Its filename is
     i386-reboot-fixup-for-wrap-2c-board-sc1100-based.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: reboot fixup for WRAP 2C board (SC1100 based)
From: "Denys" <denys@visp.net.lb>

Needed to make the wireless board, WRAP2C reboot.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot_fixups_32.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/reboot_fixups_32.c~i386-reboot-fixup-for-wrap-2c-board-sc1100-based arch/x86/kernel/reboot_fixups_32.c
--- a/arch/x86/kernel/reboot_fixups_32.c~i386-reboot-fixup-for-wrap-2c-board-sc1100-based
+++ a/arch/x86/kernel/reboot_fixups_32.c
@@ -53,6 +53,7 @@ static struct device_fixup fixups_table[
 { PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY, cs5530a_warm_reset },
 { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
 { PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030, rdc321x_reset },
+{ PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_SC1100_BRIDGE, cs5530a_warm_reset },
 };
 
 /*
_

Patches currently in -mm which might be from denys@visp.net.lb are

i386-reboot-fixup-for-wrap-2c-board-sc1100-based.patch
