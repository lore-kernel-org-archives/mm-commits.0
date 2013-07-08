From: akpm@linux-foundation.org
Subject: [merged] mm-cris-clean-up-unused-valid_page.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:28:26 -0700
Message-ID: <51db12da.H0TxZDSNnGWQy369%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3GHT22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jiang.liu@huawei.com, jesper.nilsson@axis.com, liuj97@gmail.com

Subject: [merged] mm-cris-clean-up-unused-valid_page.patch removed from -mm tree
To: liuj97@gmail.com,jesper.nilsson@axis.com,jiang.liu@huawei.com,starvik@axis.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:28:26 -0700


The patch titled
     Subject: mm/CRIS: clean up unused VALID_PAGE()
has been removed from the -mm tree.  Its filename was
     mm-cris-clean-up-unused-valid_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/CRIS: clean up unused VALID_PAGE()

VALID_PAGE() has been removed from kernel long time ago, so clean up it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/page.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/cris/include/asm/page.h~mm-cris-clean-up-unused-valid_page arch/cris/include/asm/page.h
--- a/arch/cris/include/asm/page.h~mm-cris-clean-up-unused-valid_page
+++ a/arch/cris/include/asm/page.h
@@ -51,7 +51,6 @@ typedef struct page *pgtable_t;
  */ 
 
 #define virt_to_page(kaddr)    (mem_map + (((unsigned long)(kaddr) - PAGE_OFFSET) >> PAGE_SHIFT))
-#define VALID_PAGE(page)       (((page) - mem_map) < max_mapnr)
 #define virt_addr_valid(kaddr)	pfn_valid((unsigned)(kaddr) >> PAGE_SHIFT)
 
 /* convert a page (based on mem_map and forward) to a physical address
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

