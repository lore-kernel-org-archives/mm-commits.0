From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-add-missing-line-breaks.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:18:49 -0700
Message-ID: <20200604171849.oox4FoXIY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730007AbgFDRSu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chentao107@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: add missing newline
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-add-missing-line-breaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Tao <chentao107@huawei.com>
Subject: mm/page_alloc.c: add missing newline

Add missing line breaks on pr_warn().

Link: http://lkml.kernel.org/r/20200603063547.235825-1-chentao107@huawei.com
Signed-off-by: Chen Tao <chentao107@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-add-missing-line-breaks
+++ a/mm/page_alloc.c
@@ -7182,7 +7182,7 @@ static void __init find_zone_movable_pfn
 		}
 
 		if (mem_below_4gb_not_mirrored)
-			pr_warn("This configuration results in unmirrored kernel memory.");
+			pr_warn("This configuration results in unmirrored kernel memory.\n");
 
 		goto out2;
 	}
_

Patches currently in -mm which might be from chentao107@huawei.com are
