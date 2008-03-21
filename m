From: akpm@linux-foundation.org
Subject: - xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:14 -0700
Message-ID: <200803212031.m2LKVEep009058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759576AbYCUUbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     xtensa-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/xtensa/mm/init.c~xtensa-remove-redundant-display-of-free-swap-space-in-show_mem arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/xtensa/mm/init.c
@@ -287,7 +287,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
 	i = max_mapnr;
 	while (i-- > 0) {
 		total++;
_

Patches currently in -mm which might be from hannes@saeurebad.de are

x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch

