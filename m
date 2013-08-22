From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch added
 to -mm tree
Date: Thu, 22 Aug 2013 14:46:17 -0700
Message-ID: <521686a9.7g5EAEJ9Ll9F1oZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab3HVVqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 17:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weiyj.lk@gmail.com, n-horiguchi@ah.jp.nec.com, yongjun_wei@trendmicro.com.cn

Subject: + mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch added to -mm tree
To: yongjun_wei@trendmicro.com.cn,n-horiguchi@ah.jp.nec.com,weiyj.lk@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 14:46:17 -0700


The patch titled
     From: Wei Yongjun <weiyj.lk@gmail.com>
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix
+++ a/mm/page_alloc.c
@@ -60,7 +60,6 @@
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
-#include <linux/hugetlb.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch
linux-next.patch

