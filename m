From: akpm@linux-foundation.org
Subject: - iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:38:04 -0800
Message-ID: <200802070337.m173bkJJ014230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbYBGDid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-hostfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need a space before the open brace '{'
#150: FILE: fs/hostfs/hostfs_kern.c:995:
+	if (err){

total: 1 errors, 0 warnings, 117 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hostfs/hostfs_kern.c~iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/hostfs/hostfs_kern.c
@@ -992,7 +992,7 @@ static int hostfs_fill_sb_common(struct 
 		goto out_put;
 
 	err = hostfs_read_inode(root_inode);
-	if (err){
+	if (err) {
 		/* No iput in this case because the dput does that for us */
 		dput(sb->s_root);
 		sb->s_root = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
cpusets-update_cpumask-revision.patch
drivers-edac-add-marvell-mv64x60-driver.patch
introduce-flags-for-reserve_bootmem.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
