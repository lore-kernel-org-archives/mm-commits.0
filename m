From: akpm@linux-foundation.org
Subject: - libata-portmap-remove-unused-definitions.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:39 -0700
Message-ID: <200708311656.l7VGudjs017502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443AbXHaRIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     libata-portmap: Remove unused definitions
has been removed from the -mm tree.  Its filename was
     libata-portmap-remove-unused-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata-portmap: Remove unused definitions
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

With the PCI layer properly handling legacy IDE and the kernel now using it
these can go.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/libata-portmap.h |    5 -----
 1 files changed, 5 deletions(-)

diff -puN include/asm-generic/libata-portmap.h~libata-portmap-remove-unused-definitions include/asm-generic/libata-portmap.h
--- a/include/asm-generic/libata-portmap.h~libata-portmap-remove-unused-definitions
+++ a/include/asm-generic/libata-portmap.h
@@ -1,12 +1,7 @@
 #ifndef __ASM_GENERIC_LIBATA_PORTMAP_H
 #define __ASM_GENERIC_LIBATA_PORTMAP_H
 
-#define ATA_PRIMARY_CMD		0x1F0
-#define ATA_PRIMARY_CTL		0x3F6
 #define ATA_PRIMARY_IRQ(dev)	14
-
-#define ATA_SECONDARY_CMD	0x170
-#define ATA_SECONDARY_CTL	0x376
 #define ATA_SECONDARY_IRQ(dev)	15
 
 #endif
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
git-xtensa.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
