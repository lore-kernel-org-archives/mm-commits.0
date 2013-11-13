From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-remove-unused-marco-long_align.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:44 -0800
Message-ID: <5283e354.Nk3rVdI4H7ypEg+d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-page_allocc-remove-unused-marco-long_align.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:44 -0800


The patch titled
     Subject: mm/page_alloc.c: remove unused marco LONG_ALIGN
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-remove-unused-marco-long_align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm/page_alloc.c: remove unused marco LONG_ALIGN

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-remove-unused-marco-long_align mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-remove-unused-marco-long_align
+++ a/mm/page_alloc.c
@@ -3881,8 +3881,6 @@ static inline unsigned long wait_table_b
 	return ffz(~size);
 }
 
-#define LONG_ALIGN(x) (((x)+(sizeof(long))-1)&~((sizeof(long))-1))
