From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:45 -0700
Message-ID: <20121009181245.8E4FD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63830 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab2JISMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:46 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so661050ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: remove duplicate inclusion of header file
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: mm/hugetlb.c: remove duplicate inclusion of header file

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-remove-duplicate-inclusion-of-header-file mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-remove-duplicate-inclusion-of-header-file
+++ a/mm/hugetlb.c
@@ -30,7 +30,6 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
-#include <linux/hugetlb_cgroup.h>
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

