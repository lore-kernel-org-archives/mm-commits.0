From: akpm@linux-foundation.org
Subject: - drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch removed from -mm tree
Date: Fri, 14 Sep 2007 15:18:35 -0700
Message-ID: <200709142218.l8EMIalP027046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759320AbXINWS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 18:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/mtdbdi.c is no longer an own module
has been removed from the -mm tree.  Its filename was
     drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: drivers/mtd/mtdbdi.c is no longer an own module
From: Adrian Bunk <bunk@kernel.org>

mtdbdi.c is now in the same module as mtdcore.c

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/mtd/mtdbdi.c~drivers-mtd-mtdbdic-is-no-longer-an-own-module drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~drivers-mtd-mtdbdic-is-no-longer-an-own-module
+++ a/drivers/mtd/mtdbdi.c
@@ -22,7 +22,6 @@
 struct backing_dev_info mtd_bdi_unmappable = {
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_unmappable);
 
 /*
  * backing device capabilities for R/O mappable devices (such as ROM)
@@ -33,7 +32,6 @@ struct backing_dev_info mtd_bdi_ro_mappa
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_ro_mappable);
 
 /*
  * backing device capabilities for writable mappable devices (such as RAM)
@@ -45,6 +43,4 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 			   BDI_CAP_WRITE_MAP),
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
 
-MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
net-sctp-socketc-make-3-variables-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
