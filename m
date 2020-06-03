From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 060/131] mm/page_alloc.c: add missing newline
Date: Wed, 03 Jun 2020 16:00:02 -0700
Message-ID: <20200603230002.GQYWdKrjK%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXAD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:00:03 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chentao107@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
