From: akpm@linux-foundation.org
Subject: - add-a-missing-00-index-file-for-documentation-vm.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:24 -0700
Message-ID: <200710180705.l9I75OW9031643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762236AbXJRHPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Add a missing 00-INDEX file for Documentation/vm/
has been removed from the -mm tree.  Its filename was
     add-a-missing-00-index-file-for-documentation-vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a missing 00-INDEX file for Documentation/vm/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch adds a 00-INDEX file to Documentation/vm/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 vm/00-INDEX |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN /dev/null vm/00-INDEX
--- /dev/null
+++ a/vm/00-INDEX
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
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
