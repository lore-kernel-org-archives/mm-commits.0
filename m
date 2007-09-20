From: akpm@linux-foundation.org
Subject: + add-a-missing-00-index-file-for-documentation-vm-fix.patch added to -mm tree
Date: Wed, 19 Sep 2007 23:34:42 -0700
Message-ID: <200709200634.l8K6YgqD032228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757614AbXITGes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 02:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, jesper.juhl@gmail.com


The patch titled
     doc: move vm/00-INDEX to Documentation/vm
has been added to the -mm tree.  Its filename is
     add-a-missing-00-index-file-for-documentation-vm-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
