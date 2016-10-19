From: akpm@linux-foundation.org
Subject: [merged] mm-numa-remove-duplicated-include-from-mprotectc.patch
 removed from -mm tree
Date: Wed, 19 Oct 2016 11:04:54 -0700
Message-ID: <5807b5c6.npdrpwd18mzrkrE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58715 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934641AbcJSSEz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 14:04:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyongjun1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: remove duplicated include from mprotect.c
has been removed from the -mm tree.  Its filename was
     mm-numa-remove-duplicated-include-from-mprotectc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: mm/mprotect.c: remove duplicated include from mprotect.c

Remove duplicated include.

Link: http://lkml.kernel.org/r/1476719259-6214-1-git-send-email-weiyj.lk@gmail.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mprotect.c~mm-numa-remove-duplicated-include-from-mprotectc mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-remove-duplicated-include-from-mprotectc
+++ a/mm/mprotect.c
@@ -25,7 +25,6 @@
 #include <linux/perf_event.h>
 #include <linux/pkeys.h>
 #include <linux/ksm.h>
-#include <linux/pkeys.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


