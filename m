From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:58:30 -0700
Message-ID: <5230d976.dm5TZCiMCI3vIi06%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3IKU6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:58:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, yongjun_wei@trendmicro.com.cn

Subject: [folded-merged] mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch removed from -mm tree
To: yongjun_wei@trendmicro.com.cn,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:58:30 -0700


The patch titled
     Subject: mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix.patch

This patch was dropped because it was folded into mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage-fix

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

origin.patch
block-support-embedded-device-command-line-partition.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch

