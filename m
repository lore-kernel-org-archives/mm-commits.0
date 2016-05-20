From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-kill-hook-arch_rebalance_pgtables.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:05:24 -0700
Message-ID: <573f7c14.B6sg1lTQ2Jo5AOsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: kill hook arch_rebalance_pgtables()
has been removed from the -mm tree.  Its filename was
     mm-mmap-kill-hook-arch_rebalance_pgtables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm/mmap: kill hook arch_rebalance_pgtables()

Nobody uses it.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mmap.c~mm-mmap-kill-hook-arch_rebalance_pgtables mm/mmap.c
--- a/mm/mmap.c~mm-mmap-kill-hook-arch_rebalance_pgtables
+++ a/mm/mmap.c
@@ -55,10 +55,6 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
-#ifndef arch_rebalance_pgtables
-#define arch_rebalance_pgtables(addr, len)		(addr)
-#endif
