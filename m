From: akpm@linux-foundation.org
Subject: - iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports.patch removed from -mm tree
Date: Wed, 25 Jul 2007 02:03:56 -0700
Message-ID: <200707250903.l6P93ucc026521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756139AbXGYJEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 05:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     iomap: allow space for 64bit I/O ports
has been removed from the -mm tree.  Its filename was
     iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: iomap: allow space for 64bit I/O ports
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Allow for 64bit MMIO ports in the iomap printing buffer

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/iomap.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/iomap.h~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports include/asm-generic/iomap.h
--- a/include/asm-generic/iomap.h~iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports
+++ a/include/asm-generic/iomap.h
@@ -67,7 +67,7 @@ extern void pci_iounmap(struct pci_dev *
 
 /* Convert an iomap to text for this platform */
 extern char *iomap_name(void __iomem *addr, char *buf, size_t len);
-#define IOMAP_NAMELEN	12
+#define IOMAP_NAMELEN	20
 
 
 #endif
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
git-scsi-rc-fixes.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
geode-setup-correct-chipset-access-functions-fix.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer-iomap-allow-space-for-64bit-i-o-ports.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
