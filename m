From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:06:27 -0700
Message-ID: <20120912210628.1D2815C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54068 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2ILVGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:06:30 -0400
Received: by weyr1 with SMTP id r1so146837wey.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:06:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: mm/hugetlb.c: remove duplicate inclusion of header file
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-hugetlbc-remove-duplicate-inclusion-of-header-file.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
proc-use-null-instead-of-0-for-pointer.patch

