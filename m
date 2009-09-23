From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:29:20 -0700
Message-ID: <200909232229.n8NMTKwn016940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZIWW33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch

This patch was dropped because it was folded into memcg-remove-the-overhead-associated-with-the-root-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-the-overhead-associated-with-the-root-cgroup-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix a few documentation glitches

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix
+++ a/Documentation/cgroups/memory.txt
@@ -179,8 +179,8 @@ The reclaim algorithm has not been modif
 pages that are selected for reclaiming come from the per cgroup LRU
 list.
 
-NOTE: Reclaim does not works for the root cgroup, since we cannot
-set any limits on the root cgroup
+NOTE: Reclaim does not work for the root cgroup, since we cannot set any
+limits on the root cgroup.
 
 2. Locking
 
@@ -213,7 +213,7 @@ We can alter the memory limit:
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
 NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
-NOTE: We cannot set limits on the root cgroup anymore.
+NOTE: We cannot set limits on the root cgroup any more.
 
 # cat /cgroups/0/memory.limit_in_bytes
 4194304
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

