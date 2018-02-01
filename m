From: akpm@linux-foundation.org
Subject: [merged] mm-remove-pg_highmem-description.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:35:14 -0800
Message-ID: <20180201193514.oX4cA1ByY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754690AbeBATfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:35:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove PG_highmem description
has been removed from the -mm tree.  Its filename was
     mm-remove-pg_highmem-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm: remove PG_highmem description

cbe37d093707 ("[PATCH] mm: remove PG_highmem") removed PG_highmem to save
a page flag.  So the description of PG_highmem is no longer needed.

Link: http://lkml.kernel.org/r/1517391212-2950-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/page-flags.h~mm-remove-pg_highmem-description include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-remove-pg_highmem-description
+++ a/include/linux/page-flags.h
@@ -46,11 +46,6 @@
  * guarantees that this bit is cleared for a page when it first is entered into
  * the page cache.
  *
- * PG_highmem pages are not permanently mapped into the kernel virtual address
- * space, they need to be kmapped separately for doing IO on the pages.  The
- * struct page (these bits with information) are always mapped into kernel
- * address space...
- *
  * PG_hwpoison indicates that a page got corrupted in hardware and contains
  * data with incorrect ECC bits that triggered a machine check. Accessing is
  * not safe since it may cause another machine check. Don't touch!
_

Patches currently in -mm which might be from miles.chen@mediatek.com are


