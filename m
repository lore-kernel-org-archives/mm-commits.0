From: akpm@linux-foundation.org
Subject: [merged] vmstat-fix-wrong-comment.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:41:34 -0700
Message-ID: <20170907184134.tLiEshv3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSlf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org, sj38.park@gmail.com, vbabka@suse.cz


The patch titled
     Subject: mm/vmstat.c: fix wrong comment
has been removed from the -mm tree.  Its filename was
     vmstat-fix-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/vmstat.c: fix wrong comment

Comment for pagetypeinfo_showblockcount() is mistakenly duplicated from
pagetypeinfo_show_free()'s comment.  This commit fixes it.

Link: http://lkml.kernel.org/r/20170809185816.11244-1-sj38.park@gmail.com
Fixes: 467c996c1e19 ("Print out statistics in relation to fragmentation avoidance to /proc/pagetypeinfo")
Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-fix-wrong-comment mm/vmstat.c
--- a/mm/vmstat.c~vmstat-fix-wrong-comment
+++ a/mm/vmstat.c
@@ -1255,7 +1255,7 @@ static void pagetypeinfo_showblockcount_
 	seq_putc(m, '\n');
 }
 
-/* Print out the free pages at each order for each migratetype */
+/* Print out the number of pageblocks for each migratetype */
 static int pagetypeinfo_showblockcount(struct seq_file *m, void *arg)
 {
 	int mtype;
_

Patches currently in -mm which might be from sj38.park@gmail.com are


