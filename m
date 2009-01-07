From: akpm@linux-foundation.org
Subject: - memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:15:58 -0800
Message-ID: <200901072315.n07NFxpa000604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763735AbZAGXQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, jblunck@suse.de, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, pbadari@us.ib


The patch titled
     memcg-avoid-unnecessary-system-wide-oom-killer-fix
has been removed from the -mm tree.  Its filename was
     memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch

This patch was dropped because it was folded into memcg-avoid-unnecessary-system-wide-oom-killer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-avoid-unnecessary-system-wide-oom-killer-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: Jan Blunck <jblunck@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/memcontrol.h~memcg-avoid-unnecessary-system-wide-oom-killer-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-avoid-unnecessary-system-wide-oom-killer-fix
+++ a/include/linux/memcontrol.h
@@ -236,7 +236,8 @@ static inline bool mem_cgroup_disabled(v
 {
 	return true;
 }
-static inline bool mem_cgroup_oom_called(struct task_struct *task);
+
+static inline bool mem_cgroup_oom_called(struct task_struct *task)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

