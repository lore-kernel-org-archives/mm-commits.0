From: akpm@linux-foundation.org
Subject: [to-be-updated] kexec-add-resriction-on-the-kexec_load-fix.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 16:09:17 -0700
Message-ID: <57993f1d.Vzyms64/lXfhi06D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163142AbcG0XJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 19:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-add-resriction-on-the-kexec_load-fix
has been removed from the -mm tree.  Its filename was
     kexec-add-resriction-on-the-kexec_load-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-add-resriction-on-the-kexec_load-fix

Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-fix
+++ a/kernel/kexec_core.c
@@ -215,10 +215,10 @@ int sanity_check_segment_list(struct kim
 			return -EINVAL;
 	}
 
-	/* Verity all segment size donnot exceed the specified size.
-	 * if segment size from user space is too large,  a large
-	 * amount of time will be wasted when allocating page. so,
-	 * softlockup may be come up.
+	/*
+	 * Verify that no segment is larger than half of memory.  If a segment
+	 * from userspace is too large,  a large amount of time will be wasted
+	 * allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
 		if (image->segment[i].memsz > (totalram_pages / 2))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

