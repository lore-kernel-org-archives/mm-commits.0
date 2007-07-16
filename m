From: akpm@linux-foundation.org
Subject: - buffer-kill-old-incorrect-comment.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:31 -0700
Message-ID: <200707162055.l6GKtVSP001923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758518AbXGPVPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     buffer: kill old incorrect comment
has been removed from the -mm tree.  Its filename was
     buffer-kill-old-incorrect-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: buffer: kill old incorrect comment
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/buffer.c~buffer-kill-old-incorrect-comment fs/buffer.c
--- a/fs/buffer.c~buffer-kill-old-incorrect-comment
+++ a/fs/buffer.c
@@ -1026,11 +1026,6 @@ failed:
 /*
  * Create buffers for the specified block device block's page.  If
  * that page was dirty, the buffers are set dirty also.
- *
- * Except that's a bug.  Attaching dirty buffers to a dirty
- * blockdev's page can result in filesystem corruption, because
- * some of those buffers may be aliases of filesystem data.
- * grow_dev_page() will go BUG() if this happens.
  */
 static int
 grow_buffers(struct block_device *bdev, sector_t block, int size)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-add-ioapic-nmi-support.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
