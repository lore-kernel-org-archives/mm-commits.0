From: akpm@linux-foundation.org
Subject: [merged] mm-kmemleak-remove-unused-hardirqh.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:30:30 -0800
Message-ID: <20180201193030.zyzprfrYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753007AbeBATab (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:30:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, yang.s@alibaba-inc.com


The patch titled
     Subject: mm: kmemleak: remove unused hardirq.h
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-remove-unused-hardirqh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: kmemleak: remove unused hardirq.h

Preempt counter APIs have been split out, currently, hardirq.h just
includes irq_enter/exit APIs which are not used by kmemleak at all.

So, remove the unused hardirq.h.

Link: http://lkml.kernel.org/r/1510959741-31109-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleak-remove-unused-hardirqh mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-remove-unused-hardirqh
+++ a/mm/kmemleak.c
@@ -91,7 +91,6 @@
 #include <linux/stacktrace.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <linux/bootmem.h>
 #include <linux/pfn.h>
 #include <linux/mmzone.h>
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are


