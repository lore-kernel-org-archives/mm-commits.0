From: akpm@linux-foundation.org
Subject: +
 vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 30 Nov 2016 14:27:11 -0800
Message-ID: <583f523f.BzeHUEDxTsT8bVI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36136 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbcK3W0z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch

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
@@ -1364,7 +1364,7 @@ int may_umount_tree(struct vfsmount *m)
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
scripts-checkpatchpl-fix-spelling.patch
vfs-make-may_umount_tree-mount-propogation-aware-checkpatch-fixes.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

