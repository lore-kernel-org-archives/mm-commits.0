From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 25/25] mm/madvise.c: remove duplicated include
Date: Wed, 10 Jun 2020 18:42:45 -0700
Message-ID: <20200611014245.BBQrFtR6x%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFKBmq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:42:46 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jrdr.linux@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yuehaibing@huawei.com

From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/madvise.c: remove duplicated include

Remove duplicated include.

Link: http://lkml.kernel.org/r/20200505100049.191351-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mm-remove-duplicated-include-from-madvisec
+++ a/mm/madvise.c
@@ -29,7 +29,6 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
-#include <linux/sched/mm.h>
 #include <linux/uio.h>
 
 #include <asm/tlb.h>
_
