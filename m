From: akpm@linux-foundation.org
Subject: + mm-numa-remove-duplicated-include-from-mprotectc.patch added to -mm tree
Date: Mon, 17 Oct 2016 16:08:06 -0700
Message-ID: <580559d6.Br6CGHLj8LqHOQFb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58319 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932614AbcJQXIH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 19:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyongjun1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect.c: remove duplicated include from mprotect.c
has been added to the -mm tree.  Its filename is
     mm-numa-remove-duplicated-include-from-mprotectc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-remove-duplicated-include-from-mprotectc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-remove-duplicated-include-from-mprotectc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-numa-remove-duplicated-include-from-mprotectc.patch

