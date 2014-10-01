From: akpm@linux-foundation.org
Subject: + mm-mremap-use-linux-headers.patch added to -mm tree
Date: Wed, 01 Oct 2014 12:58:38 -0700
Message-ID: <542c5cee.rtWo4X2PFRwUfKEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaJAT6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 15:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap.c: use linux headers
has been added to the -mm tree.  Its filename is
     mm-mremap-use-linux-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-use-linux-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-use-linux-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: mm/mremap.c: use linux headers

"WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>"

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mremap.c~mm-mremap-use-linux-headers mm/mremap.c
--- a/mm/mremap.c~mm-mremap-use-linux-headers
+++ a/mm/mremap.c
@@ -21,8 +21,8 @@
 #include <linux/syscalls.h>
 #include <linux/mmu_notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

mm-mremap-use-linux-headers.patch

