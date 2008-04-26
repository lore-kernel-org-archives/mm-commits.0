From: akpm@linux-foundation.org
Subject: - arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:20 -0700
Message-ID: <200804261640.m3QGeKXD031022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523AbYDZQlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:41:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: remove redundant display of free swap space in show_mem()
has been removed from the -mm tree.  Its filename was
     arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: remove redundant display of free swap space in show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/arm/mm/init.c~arm-remove-redundant-display-of-free-swap-space-in-show_mem arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-remove-redundant-display-of-free-swap-space-in-show_mem
+++ a/arch/arm/mm/init.c
@@ -48,8 +48,6 @@ void show_mem(void)
 
 	printk("Mem-info:\n");
 	show_free_areas();
-	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
