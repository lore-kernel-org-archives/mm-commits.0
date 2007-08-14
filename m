From: akpm@linux-foundation.org
Subject: - fore200e_param_bs_queue-must-be-__devinit.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:21 -0700
Message-ID: <200708141912.l7EJCLxq016398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934756AbXHNTMh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     fore200e_param_bs_queue() must be __devinit
has been removed from the -mm tree.  Its filename was
     fore200e_param_bs_queue-must-be-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fore200e_param_bs_queue() must be __devinit
From: Adrian Bunk <bunk@stusta.de>

WARNING: drivers/built-in.o(.text+0x6203bb): Section mismatch: reference to .init.text:fore200e_param_bs_queue (between 'fore200e_initialize' and 'fore200e_monitor_putc')

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/fore200e.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/atm/fore200e.c~fore200e_param_bs_queue-must-be-__devinit drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~fore200e_param_bs_queue-must-be-__devinit
+++ a/drivers/atm/fore200e.c
@@ -2435,7 +2435,7 @@ fore200e_init_cmd_queue(struct fore200e*
 }
 
 
-static void __init
+static void __devinit
 fore200e_param_bs_queue(struct fore200e* fore200e,
 			enum buffer_scheme scheme, enum buffer_magn magn,
 			int queue_length, int pool_size, int supply_blksize)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
kernel-auditscc-fix-an-off-by-one.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-netdev-all.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
