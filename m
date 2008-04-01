From: akpm@linux-foundation.org
Subject: - s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:30 -0700
Message-ID: <200804012138.m31LcUxv014929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758658AbYDAVry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/s390/mm/init.c~s390-remove-redundant-display-of-free-swap-space-in-show_mem arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~s390-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/s390/mm/init.c
@@ -50,7 +50,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
 	i = max_mapnr;
 	while (i-- > 0) {
 		if (!pfn_valid(i))
_

Patches currently in -mm which might be from hannes@saeurebad.de are

x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-s390.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

