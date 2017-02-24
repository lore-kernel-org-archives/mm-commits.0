From: akpm@linux-foundation.org
Subject: [patch 067/124] mm/page_alloc.c: remove duplicate inclusion of
 page_ext.h
Date: Fri, 24 Feb 2017 14:58:56 -0800
Message-ID: <58b0bab0.z7M3QKWY9p41WZF9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdBXW7C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, standby24x7@gmail.com

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
