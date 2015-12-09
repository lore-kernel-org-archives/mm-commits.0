From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 09 Dec 2015 14:12:09 -0800
Message-ID: <5668a739.TIS/uiGWyqa7PeX2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbLIWMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2015 17:12:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memblock-use-memblock_insert_region-for-the-empty-array.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#29: FILE: mm/memblock.c:497:
+	if (idx)
+	{

total: 1 errors, 0 warnings, 30 lines checked

./patches/mm-memblock-use-memblock_insert_region-for-the-empty-array.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-memblock_insert_region-for-the-empty-array-checkpatch-fixes
+++ a/mm/memblock.c
@@ -494,8 +494,7 @@ static void __init_memblock memblock_ins
 
 	BUG_ON(type->cnt >= type->max);
 	/* special case for empty array */
-	if (idx)
-	{
+	if (idx) {
 		memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
 		type->cnt++;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
mm-memblock-use-memblock_insert_region-for-the-empty-array.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

