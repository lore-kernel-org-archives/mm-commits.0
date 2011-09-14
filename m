From: akpm@linux-foundation.org
Subject: [folded] mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch removed from -mm tree
Date: Wed, 14 Sep 2011 16:17:17 -0700
Message-ID: <201109142317.p8ENHIl5006387@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:54240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1INXR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 19:17:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jweiner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-vmscan-fix-force-scanning-small-targets-without-swap-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-force-scanning-small-targets-without-swap-fix.patch

This patch was dropped because it was folded into mm-vmscan-fix-force-scanning-small-targets-without-swap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-vmscan-fix-force-scanning-small-targets-without-swap-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment

Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-force-scanning-small-targets-without-swap-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-force-scanning-small-targets-without-swap-fix
+++ a/mm/vmscan.c
@@ -1833,7 +1833,7 @@ static void get_scan_count(struct zone *
 	bool force_scan = false;
 	unsigned long nr_force_scan[2];
 
-	/* kswapd does zone balancing and need to scan this zone */
+	/* kswapd does zone balancing and needs to scan this zone */
 	if (scanning_global_lru(sc) && current_is_kswapd())
 		force_scan = true;
 	/* memcg may have small limit and need to avoid priority drop */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
mm-vmscan-fix-force-scanning-small-targets-without-swap.patch
rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
sound-core-pcm_libc-fix-race-condition-in-wait_for_avail-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch
dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements-checkpatch-fixes.patch
block-document-blk-plug.patch
block-document-blk-plug-v3-fix.patch
block-blk-sysfsc-fix-kerneldoc-references.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
cgroups-add-a-task-counter-subsystem.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
aio-allocate-kiocbs-in-batches-fix.patch
aio-allocate-kiocbs-in-batches-fix-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

