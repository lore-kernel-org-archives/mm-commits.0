From: akpm@linux-foundation.org
Subject: [folded] hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:34:15 -0700
Message-ID: <200909212134.n8LLYFQd029335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbZIUVe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agl@us.ibm.com, arnd@arndb.de, david@gibson.dropbear.id.au, ebmunson@us.ibm.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpig


The patch titled
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch

This patch was dropped because it was folded into hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix
From: Andrew Morton <akpm@linux-foundation.org>

Unneeded with Arnd's
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch.

Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/mman-common.h |    1 -
 mmap.c                            |    0 
 2 files changed, 1 deletion(-)

diff -puN include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix
+++ a/include/asm-generic/mman-common.h
@@ -19,7 +19,6 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
-#define MAP_HUGETLB	0x40		/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
diff -puN include/linux/hugetlb.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix include/linux/hugetlb.h
diff -puN mm/mmap.c~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix mm/mmap.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
drivers-mfd-ab3100-corec-fiw-warning-and-powerpc-build-error.patch
mm-make-swap-token-dummies-static-inlines.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-convert-to-use-arch_gettimeoffset-fix.patch
cpuidle-fix-the-menu-governor-to-boost-io-performance.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it-fix.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

