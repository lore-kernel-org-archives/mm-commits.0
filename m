From: akpm@osdl.org
Subject: - mention-jffs-impending-death.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:54 -0800
Message-ID: <200701260751.l0Q7psQO010774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50513 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030819AbXAZHwB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:52:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     mention JFFS impending death
has been removed from the -mm tree.  Its filename was
     mention-jffs-impending-death.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mention JFFS impending death
From: Jeff Garzik <jeff@garzik.org>

JFFS is already marked CONFIG_BROKEN in fs/Kconfig, with a note that it's
going away in 2.6.21, but the corresponding update to
feature-removal-schedule.txt was accidentally omitted.  Fixed.


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/feature-removal-schedule.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/feature-removal-schedule.txt~mention-jffs-impending-death Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mention-jffs-impending-death
+++ a/Documentation/feature-removal-schedule.txt
@@ -302,3 +302,10 @@ Why:	/proc/acpi/button has been replaced
 Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
+
+What:	JFFS (version 1)
+When:	2.6.21
+Why:	Unmaintained for years, superceded by JFFS2 for years.
+Who:	Jeff Garzik <jeff@garzik.org>
+
+---------------------------
_

Patches currently in -mm which might be from jeff@garzik.org are

netdev-add-a-maintainers-entry-for-via-velocity-and-update-my-address.patch
git-libata-all.patch
libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
net-ifb-error-path-loop-fix.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
remove-one-remaining-define-bcm_tso-1.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
tulip-fix-shutdown-dma-irq-race.patch
z85230-spinlock-logic.patch
remove-unused-kernel-config-option-dlci_count.patch
git-ioat.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch
uml-network-driver-whitespace-and-style-fixes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch
