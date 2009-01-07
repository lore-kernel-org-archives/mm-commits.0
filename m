From: akpm@linux-foundation.org
Subject: - memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:14:06 -0800
Message-ID: <200901072314.n07NE6so031529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763500AbZAGXO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@ope


The patch titled
     memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch

This patch was dropped because it was folded into memory-cgroup-resource-counters-for-hierarchy-v4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#192: FILE: mm/memcontrol.c:1721:
+ ^Ires_counter_init(&mem->res, parent ? &parent->res : NULL);$

total: 1 errors, 0 warnings, 146 lines checked

./patches/memory-cgroup-resource-counters-for-hierarchy-v4.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1728,7 +1728,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	} else
 		parent = mem_cgroup_from_cont(cont->parent);
 
- 	res_counter_init(&mem->res, parent ? &parent->res : NULL);
+	res_counter_init(&mem->res, parent ? &parent->res : NULL);
 	res_counter_init(&mem->memsw, parent ? &parent->memsw : NULL);
 
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
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

