From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 13 May 2014 11:53:37 -0700
Message-ID: <53726a31.19PEdwW9/GUzBzG/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaEMSxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 14:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 11:53:37 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts |    3 ---
 arch/arm/boot/dts/kirkwood-t5325.dts           |    3 ---
 drivers/memory/mvebu-devbus.c                  |    9 ---------
 3 files changed, 15 deletions(-)

diff -puN arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts~linux-next-git-rejects arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -75,13 +75,10 @@
 		serial@12000 {
 			status = "okay";
 		};
-<<<<<<< HEAD
-=======
 
 		ehci@50000 {
 			status = "okay";
 		};
->>>>>>> linux-next/akpm-base
 	};
 
 	gpio-leds {
diff -puN arch/arm/boot/dts/kirkwood-t5325.dts~linux-next-git-rejects arch/arm/boot/dts/kirkwood-t5325.dts
--- a/arch/arm/boot/dts/kirkwood-t5325.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/kirkwood-t5325.dts
@@ -122,8 +122,6 @@
 
 		i2c@11000 {
 			status = "okay";
-<<<<<<< HEAD
-=======
 
 			alc5621: alc5621@1a {
 				compatible = "realtek,alc5621";
@@ -132,7 +130,6 @@
 				add-ctrl = <0x3700>;
 				jack-det-ctrl = <0x4810>;
 			};
->>>>>>> linux-next/akpm-base
 		};
 
 		serial@12000 {
diff -puN drivers/memory/mvebu-devbus.c~linux-next-git-rejects drivers/memory/mvebu-devbus.c
--- a/drivers/memory/mvebu-devbus.c~linux-next-git-rejects
+++ a/drivers/memory/mvebu-devbus.c
@@ -136,21 +136,12 @@ static int devbus_get_timing_params(stru
 	 * The bus width is encoded into the register as 0 for 8 bits,
 	 * and 1 for 16 bits, so we do the necessary conversion here.
 	 */
-<<<<<<< HEAD
-	if (r.bus_width == 8)
-		r.bus_width = 0;
-	else if (r.bus_width == 16)
-		r.bus_width = 1;
-	else {
-		dev_err(devbus->dev, "invalid bus width %d\n", r.bus_width);
-=======
 	if (r->bus_width == 8)
 		r->bus_width = 0;
 	else if (r->bus_width == 16)
 		r->bus_width = 1;
 	else {
 		dev_err(devbus->dev, "invalid bus width %d\n", r->bus_width);
->>>>>>> linux-next/akpm-base
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

