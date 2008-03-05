From: akpm@linux-foundation.org
Subject: - x86-a-p4-is-a-p6-not-an-i486.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:47:08 -0800
Message-ID: <200803050747.m257l8uq021831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759996AbYCEHsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     x86: a P4 is a P6 not an i486
has been removed from the -mm tree.  Its filename was
     x86-a-p4-is-a-p6-not-an-i486.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: a P4 is a P6 not an i486
From: Hugh Dickins <hugh@veritas.com>

P4 has been coming out as CPU_FAMILY=4 instead of 6: fix MPENTIUM4 typo.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.cpu |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/Kconfig.cpu~x86-a-p4-is-a-p6-not-an-i486 arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu~x86-a-p4-is-a-p6-not-an-i486
+++ a/arch/x86/Kconfig.cpu
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || PENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
 
 config X86_TSC
 	def_bool y
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

