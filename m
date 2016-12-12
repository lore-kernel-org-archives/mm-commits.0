From: akpm@linux-foundation.org
Subject: [obsolete]
 vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 12 Dec 2016 13:41:57 -0800
Message-ID: <584f19a5.tcPls7sgWXXuv4tk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcLLVl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 16:41:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes

WARNING: 'minumum' may be misspelled - perhaps 'minimum'?
#114: FILE: fs/namespace.c:1367:
+	 * to the tree at mnt is one greater than the minumum

WARNING: function definition argument 'struct mount *' should also have an identifier name
#168: FILE: fs/pnode.h:41:
+struct mount *propagation_next(struct mount *, struct mount *);

WARNING: function definition argument 'struct mount *' should also have an identifier name
#168: FILE: fs/pnode.h:41:
+struct mount *propagation_next(struct mount *, struct mount *);

total: 0 errors, 3 warnings, 125 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/vfs-make-may_umount_tree-mount-propogation-aware.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes fs/namespace.c
--- a/fs/namespace.c~vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes
+++ a/fs/namespace.c
@@ -1365,7 +1365,7 @@ int may_umount_tree(struct vfsmount *m)
 	mnt_get_tree_refs(&mtr);
 	/*
 	 * Caller holds a mount reference so minimum references
-	 * to the tree at mnt is one greater than the minumum
+	 * to the tree at mnt is one greater than the minimum
 	 * references.
 	 */
 	mtr.min_refs++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

