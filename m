From: akpm@linux-foundation.org
Subject: + libata-misc-minor-merge-fixups.patch added to -mm tree
Date: Sun, 25 Mar 2007 00:53:27 -0800
Message-ID: <200703250853.l2P8rR7h024135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXCYIxl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 04:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     libata: Misc minor merge fixups
has been added to the -mm tree.  Its filename is
     libata-misc-minor-merge-fixups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata: Misc minor merge fixups
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Nothing terribly exciting here just odd glitches from the merge

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt366.c      |    1 -
 drivers/ata/pata_serverworks.c |    1 -
 drivers/ata/pata_sis.c         |    2 --
 3 files changed, 4 deletions(-)

diff -puN drivers/ata/pata_hpt366.c~libata-misc-minor-merge-fixups drivers/ata/pata_hpt366.c
--- a/drivers/ata/pata_hpt366.c~libata-misc-minor-merge-fixups
+++ a/drivers/ata/pata_hpt366.c
@@ -169,7 +169,6 @@ static int hpt_dma_blacklisted(const str
 
 /**
  *	hpt366_filter	-	mode selection filter
- *	@ap: ATA interface
  *	@adev: ATA device
  *
  *	Block UDMA on devices that cause trouble with this controller.
diff -puN drivers/ata/pata_serverworks.c~libata-misc-minor-merge-fixups drivers/ata/pata_serverworks.c
--- a/drivers/ata/pata_serverworks.c~libata-misc-minor-merge-fixups
+++ a/drivers/ata/pata_serverworks.c
@@ -139,7 +139,6 @@ static struct sv_cable_table cable_detec
 /**
  *	serverworks_cable_detect	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection according to the device and subvendor
  *	identifications
diff -puN drivers/ata/pata_sis.c~libata-misc-minor-merge-fixups drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~libata-misc-minor-merge-fixups
+++ a/drivers/ata/pata_sis.c
@@ -88,7 +88,6 @@ static int sis_port_base(struct ata_devi
 /**
  *	sis_133_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection for the later UDMA133 capable
  *	SiS chipset.
@@ -109,7 +108,6 @@ static int sis_133_cable_detect(struct a
 /**
  *	sis_66_cable_detect	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection on the UDMA66, UDMA100 and early UDMA133
  *	SiS IDE controllers.
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

generic_serial-fix-decoding-of-baud-rate.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-misc-minor-merge-fixups.patch
tty-minor-merge-correction.patch
pata_pdc202xx_old-lba48-bug.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
pata_pdc2027x-bring-into-line-with-changes-add-the-mode.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
