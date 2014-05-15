From: akpm@linux-foundation.org
Subject: + mm-exclude-duplicate-header.patch added to -mm tree
Date: Thu, 15 May 2014 16:00:07 -0700
Message-ID: <537546f7.F2jTyL6mmAyJgIjm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaEOXAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com

Subject: + mm-exclude-duplicate-header.patch added to -mm tree
To: andriy.shevchenko@linux.intel.com
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:00:07 -0700


The patch titled
     Subject: include/linux/gfp.h: exclude duplicate header
has been added to the -mm tree.  Its filename is
     mm-exclude-duplicate-header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-exclude-duplicate-header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-exclude-duplicate-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/gfp.h: exclude duplicate header

mmdebug.h is included twice.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/gfp.h~mm-exclude-duplicate-header include/linux/gfp.h
--- a/include/linux/gfp.h~mm-exclude-duplicate-header
+++ a/include/linux/gfp.h
@@ -6,7 +6,6 @@
 #include <linux/stddef.h>
 #include <linux/linkage.h>
 #include <linux/topology.h>
-#include <linux/mmdebug.h>
 
 struct vm_area_struct;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-dmapoolc-reuse-devres_release-to-free-resources.patch
mm-exclude-duplicate-header.patch
printk-fix-lockdep-instrumentation-of-console_sem.patch
linux-next.patch

