From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-duplicate-page_exth.patch added to -mm
 tree
Date: Thu, 02 Feb 2017 15:15:56 -0800
Message-ID: <5893bdac.6AiaUY/FHbPDn24t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbdBBXQH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 18:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove duplicate inclusion of page_ext.h
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-duplicate-page_exth.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-duplicate-page_exth.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-duplicate-page_exth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masanari Iida <standby24x7@gmail.com>
Subject: mm/page_alloc.c: remove duplicate inclusion of page_ext.h

Link: http://lkml.kernel.org/r/20170202011942.1609-1-standby24x7@gmail.com
Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-duplicate-page_exth mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-duplicate-page_exth
+++ a/mm/page_alloc.c
@@ -58,7 +58,6 @@
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
-#include <linux/page_ext.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 #include <linux/page_owner.h>
_

Patches currently in -mm which might be from standby24x7@gmail.com are

mm-page_alloc-remove-duplicate-page_exth.patch

