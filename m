From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-add-missing-line-breaks.patch added to
 -mm tree
Date: Wed, 03 Jun 2020 13:08:26 -0700
Message-ID: <20200603200826.6jLFbycRp%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCUI2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 16:08:28 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chentao107@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: add missing newline
has been added to the -mm tree.  Its filename is
     mm-page_allocc-add-missing-line-breaks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-add-missing-line-breaks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-add-missing-line-breaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7194,7 +7194,7 @@ static void __init find_zone_movable_pfn
 		}
 
 		if (mem_below_4gb_not_mirrored)
-			pr_warn("This configuration results in unmirrored kernel memory.");
+			pr_warn("This configuration results in unmirrored kernel memory.\n");
 
 		goto out2;
 	}
_

Patches currently in -mm which might be from chentao107@huawei.com are

mm-page_allocc-add-missing-line-breaks.patch
