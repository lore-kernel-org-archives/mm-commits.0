From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch
 removed from -mm tree
Date: Wed, 08 Apr 2020 17:57:39 -0700
Message-ID: <20200409005739.alSCVtOYv%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgDIA5j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:57:39 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, guro@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup cmdline_parse_hugetlb_cma()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix.patch

This patch was dropped because it was folded into mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma.patch

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: cleanup cmdline_parse_hugetlb_cma()

Remove unused code.

Link: http://lkml.kernel.org/r/20200313005500.GB5764@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-optionally-allocate-gigantic-hugepages-using-cma-fix
+++ a/mm/hugetlb.c
@@ -5543,13 +5543,6 @@ static unsigned long hugetlb_cma_size __
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
 {
-	unsigned long long val;
-	char *endptr;
-
-	if (!p)
-		return -EINVAL;
