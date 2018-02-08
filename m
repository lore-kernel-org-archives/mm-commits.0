From: akpm@linux-foundation.org
Subject: +
 mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch added to -mm tree
Date: Thu, 08 Feb 2018 11:53:09 -0800
Message-ID: <5a7caaa5.wdzI7hl6TI5c4bIv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbeBHTxK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 14:53:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool.c: zpool_evictable: fix mismatch in parameter name and kernel-doc
has been added to the -mm tree.  Its filename is
     mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm/zpool.c: zpool_evictable: fix mismatch in parameter name and kernel-doc

Link: http://lkml.kernel.org/r/1518116984-21141-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zpool.c~mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc mm/zpool.c
--- a/mm/zpool.c~mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc
+++ a/mm/zpool.c
@@ -360,7 +360,7 @@ u64 zpool_get_total_size(struct zpool *z
 
 /**
  * zpool_evictable() - Test if zpool is potentially evictable
- * @pool	The zpool to test
+ * @zpool	The zpool to test
  *
  * Zpool is only potentially evictable when it's created with struct
  * zpool_ops.evict and its driver implements struct zpool_driver.shrink.
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch

