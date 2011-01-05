From: akpm@linux-foundation.org
Subject: [withdrawn] gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:11:16 -0800
Message-ID: <201101050011.p050BGOj032264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab1AEAL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:11:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jj@chaosbits.net, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#37: FILE: usr/gen_init_cpio.c:318:
+	retval = fstat (file, &buf);

WARNING: space prohibited between function name and open parenthesis '('
#39: FILE: usr/gen_init_cpio.c:320:
+		fprintf (stderr, "File %s could not be stat()'ed\n", location);

total: 0 errors, 2 warnings, 24 lines checked

./patches/gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN usr/gen_init_cpio.c~gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes
+++ a/usr/gen_init_cpio.c
@@ -315,9 +315,9 @@ static int cpio_mkfile(const char *name,
 		goto error;
 	}
 
-	retval = fstat (file, &buf);
+	retval = fstat(file, &buf);
 	if (retval) {
-		fprintf (stderr, "File %s could not be stat()'ed\n", location);
+		fprintf(stderr, "File %s could not be stat()'ed\n", location);
 		goto error;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

