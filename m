From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 03 Apr 2014 11:21:43 -0700
Message-ID: <533da6b7.2/YSO63VaiI5mR2w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaDCSVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 14:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 11:21:43 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/phy/samsung-phy.txt |    3 ---
 arch/arm/Kconfig                                      |    4 ----
 arch/arm/mach-tegra/Kconfig                           |    4 ----
 drivers/phy/Kconfig                                   |    4 ----
 fs/bio-integrity.c                                    |    7 -------
 5 files changed, 22 deletions(-)

diff -puN Documentation/devicetree/bindings/phy/samsung-phy.txt~linux-next-git-rejects Documentation/devicetree/bindings/phy/samsung-phy.txt
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -21,8 +21,6 @@ Required properties:
 - reg : offset and length of the Display Port PHY register set;
 - #phy-cells : from the generic PHY bindings, must be 0;
 
-<<<<<<< HEAD
-=======
 Samsung SATA PHY Controller
 ---------------------------
 
@@ -63,7 +61,6 @@ Example:
 		reg = <0x38>;
 	};
 
->>>>>>> linux-next/akpm-base
 Samsung S5P/EXYNOS SoC series USB PHY
 -------------------------------------------------
 
diff -puN arch/arm/Kconfig~linux-next-git-rejects arch/arm/Kconfig
--- a/arch/arm/Kconfig~linux-next-git-rejects
+++ a/arch/arm/Kconfig
@@ -632,10 +632,6 @@ config ARCH_LPC32XX
 	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select HAVE_IDE
-<<<<<<< HEAD
-	select HAVE_PWM
-=======
->>>>>>> linux-next/akpm-base
 	select USE_OF
 	help
 	  Support for the NXP LPC32XX family of processors
diff -puN arch/arm/mach-tegra/Kconfig~linux-next-git-rejects arch/arm/mach-tegra/Kconfig
--- a/arch/arm/mach-tegra/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-tegra/Kconfig
@@ -12,10 +12,6 @@ config ARCH_TEGRA
 	select ARCH_HAS_RESET_CONTROLLER
 	select RESET_CONTROLLER
 	select SOC_BUS
-<<<<<<< HEAD
-	select SPARSE_IRQ
-=======
->>>>>>> linux-next/akpm-base
 	select USB_ULPI if USB_PHY
 	select USB_ULPI_VIEWPORT if USB_PHY
 	help
diff -puN drivers/phy/Kconfig~linux-next-git-rejects drivers/phy/Kconfig
--- a/drivers/phy/Kconfig~linux-next-git-rejects
+++ a/drivers/phy/Kconfig
@@ -27,11 +27,7 @@ config PHY_EXYNOS_MIPI_VIDEO
 
 config PHY_MVEBU_SATA
 	def_bool y
-<<<<<<< HEAD
-	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
-=======
 	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD || MACH_DOVE
->>>>>>> linux-next/akpm-base
 	depends on OF
 	select GENERIC_PHY
 
diff -puN fs/bio-integrity.c~linux-next-git-rejects fs/bio-integrity.c
--- a/fs/bio-integrity.c~linux-next-git-rejects
+++ a/fs/bio-integrity.c
@@ -312,11 +312,7 @@ static int bio_integrity_generate_verify
 	struct bio_vec bv;
 	struct bvec_iter iter;
 	sector_t sector;
-<<<<<<< HEAD
-	unsigned int sectors, ret = 0;
-=======
 	unsigned int sectors, total, ret;
->>>>>>> linux-next/akpm-base
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
 	if (operate)
@@ -324,10 +320,7 @@ static int bio_integrity_generate_verify
 	else
 		sector = bio->bi_integrity->bip_iter.bi_sector;
 
-<<<<<<< HEAD
-=======
 	total = ret = 0;
->>>>>>> linux-next/akpm-base
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
fanotify-use-fanotify-event-structure-for-permission-response-processing-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
ocfs2-rollback-alloc_dinode-counts-when-ocfs2_block_group_set_bits-failed-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
xattr-guard-against-simultaneous-glibc-header-inclusion-v2.patch
lib-syscallc-unexport-task_current_syscall.patch
scripts-checkpatchpl-__gfp_nofail-isnt-going-away.patch
checkpatch-expand-parenthesis-alignment-test-to-declarations-functions-and-assignments-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

