From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-remove-duplicate-page_exth.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:27:08 -0800
Message-ID: <58b48b9c.saZcHICxqSvZtZ9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60860 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove duplicate inclusion of page_ext.h
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-duplicate-page_exth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -59,7 +59,6 @@
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
-#include <linux/page_ext.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 #include <linux/page_owner.h>
_

Patches currently in -mm which might be from standby24x7@gmail.com are


