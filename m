From: akpm@linux-foundation.org
Subject: + sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch added to -mm tree
Date: Fri, 13 Jul 2007 17:00:07 -0700
Message-ID: <200707140000.l6E007CD030164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759347AbXGNAA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 20:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     sata_mv: test patch for Hightpoint RocketRaid 1740/1742
has been added to the -mm tree.  Its filename is
     sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_mv: test patch for Hightpoint RocketRaid 1740/1742
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Underneath all the HPT packaging, PCI identifiers, binary driver modules
and stuff you find that ...

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/ata/sata_mv.c~sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742 drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742
+++ a/drivers/ata/sata_mv.c
@@ -620,6 +620,9 @@ static const struct pci_device_id mv_pci
 	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
 	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1740/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-powerpc.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
git-scsi-misc.patch
ppa-coding-police-and-printk-levels.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
h8300-enable-arbitary-speed-tty-port-setup.patch
arm26-enable-arbitary-speed-tty-ioctls-and-split.patch
m32r-enable-arbitary-speed-tty-rate-setting.patch
etrax-enable-arbitary-speed-setting-on-tty-ports.patch
v850-enable-arbitary-speed-tty-ioctls.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
mpu401-warning-fixes.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
improve-behaviour-of-spurious-irq-detect.patch
audit-add-tty-input-auditing.patch
revert-vanishing-ioctl-handler-debugging.patch
amiserial-remove-incorrect-no-termios-change-check.patch
genericserial-remove-bogus-optimisation-check-and-dead-code-paths.patch
synclink-remove-bogus-no-change-termios-optimisation.patch
68360serial-remove-broken-optimisation.patch
serial-remove-termios-checks-from-various-old-char-serial.patch
ia64-arbitary-speed-tty-ioctl-support.patch
sb1250-duartc-sb1250-duart-serial-support.patch
mbcs-remove-lots-of-global-symbols.patch
generic_nvram-use-i_mutex-not-lock_kernel.patch
generic_nvram-use-i_mutex-not-lock_kernel-fix.patch
i2o_cfg_passthru-cleanup.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
stallion-remove-unneeded-lock_kernel.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
driver-edac-add-mips-and-ppc-visibility.patch
driver-edac-mod-race-fix-i82875p.patch
driver-edac-fix-ignored-return-i82875p.patch
include-linux-pci_id-h-add-amd-northbridge-defines.patch
drivers-edac-fix-edac_device-semaphore-to-mutex.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-fix-leaf-sysfs-attribute.patch
drivers-edac-fix-edac_mc-init-apis.patch
drivers-edac-fix-edac_device-init-apis.patch
drivers-edac-fix-edac_mc-sysfs-completion-code.patch
drivers-edac-fix-edac_device-sysfs-completion-code.patch
