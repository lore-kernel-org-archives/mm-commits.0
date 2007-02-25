From: akpm@linux-foundation.org
Subject: + siimage-drac4-note.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:13:57 -0800
Message-ID: <200702251313.l1PDDx40030028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964953AbXBYNOR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:14:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     siimage: DRAC4 note
has been added to the -mm tree.  Its filename is
     siimage-drac4-note.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: siimage: DRAC4 note
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Revised DRAC4 warning as Jeff suggested, this one includes more info about
why the problem occurs

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/pci/siimage.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/ide/pci/siimage.c~siimage-drac4-note drivers/ide/pci/siimage.c
--- a/drivers/ide/pci/siimage.c~siimage-drac4-note
+++ a/drivers/ide/pci/siimage.c
@@ -26,6 +26,11 @@
  *	If you have strange problems with nVidia chipset systems please
  *	see the SI support documentation and update your system BIOS
  *	if neccessary
+ *
+ *  The Dell DRAC4 has some interesting features including effectively hot
+ *  unplugging/replugging the virtual CD interface when the DRAC is reset.
+ *  This often causes drivers/ide/siimage to panic but is ok with the rather
+ *  smarter code in libata.
  */
 
 #include <linux/types.h>
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
libata-warn-if-speed-limited-due-to-40-wire-cable-v2.patch
add-id_to_dma_mode-function-for-printing-dma-modes.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
libata-use-new-id_to_dma_mode-function-to-tidy-reporting.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
ide-remove-a-ton-of-pointless-undef-really_slow_io.patch
siimage-drac4-note.patch
net-remove-a-collection-of-unneeded-undef-really_slow_io.patch
resend-iphase-64bit-cleanup.patch
serial-serial_txx9-driver-update.patch
serial-serial_txx9-driver-update-fix.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-clarify-documentation-of-write.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
