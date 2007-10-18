From: akpm@linux-foundation.org
Subject: - add-a-missing-00-index-file-for-documentation-vm-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:17 -0700
Message-ID: <200710180704.l9I74How031538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60144 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756921AbXJRHWd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:22:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     doc: move vm/00-INDEX to Documentation/vm
has been removed from the -mm tree.  Its filename was
     add-a-missing-00-index-file-for-documentation-vm-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: doc: move vm/00-INDEX to Documentation/vm
From: David Rientjes <rientjes@google.com>

Looks like the 00-INDEX file lost its parent directory in -rc6-mm1.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/00-INDEX |   20 ++++++++++++++++++++
 vm/00-INDEX               |   20 --------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN /dev/null Documentation/vm/00-INDEX
--- /dev/null
+++ a/Documentation/vm/00-INDEX
@@ -0,0 +1,20 @@
+00-INDEX
+	- this file.
+balance
+	- various information on memory balancing.
+hugetlbpage.txt
+	- a brief summary of hugetlbpage support in the Linux kernel.
+locking
+	- info on how locking and synchronization is done in the Linux vm code.
+numa
+	- information about NUMA specific code in the Linux vm.
+numa_memory_policy.txt
+	- documentation of concepts and APIs of the 2.6 memory policy support.
+overcommit-accounting
+	- description of the Linux kernels overcommit handling modes.
+page_migration
+	- description of page migration in NUMA systems.
+slabinfo.c
+	- source code for a tool to get reports about slabs.
+slub.txt
+	- a short users guide for SLUB.
diff -puN vm/00-INDEX~add-a-missing-00-index-file-for-documentation-vm-fix /dev/null
--- a/vm/00-INDEX
+++ /dev/null
@@ -1,20 +0,0 @@
-00-INDEX
-	- this file.
-balance
-	- various information on memory balancing.
-hugetlbpage.txt
-	- a brief summary of hugetlbpage support in the Linux kernel.
-locking
-	- info on how locking and synchronization is done in the Linux vm code.
-numa
-	- information about NUMA specific code in the Linux vm.
-numa_memory_policy.txt
-	- documentation of concepts and APIs of the 2.6 memory policy support.
-overcommit-accounting
-	- description of the Linux kernels overcommit handling modes.
-page_migration
-	- description of page migration in NUMA systems.
-slabinfo.c
-	- source code for a tool to get reports about slabs.
-slub.txt
-	- a short users guide for SLUB.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
