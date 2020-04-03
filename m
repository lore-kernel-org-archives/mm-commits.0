From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:35:14 -0700
Message-ID: <20200403203514.dakEkalZk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: correct annotation from "l_next_rec" to "l_next_free_rec"
has been removed from the -mm tree.  Its filename was
     ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: wangyan <wangyan122@huawei.com>
Subject: ocfs2: correct annotation from "l_next_rec" to "l_next_free_rec"

Correct annotation from "l_next_rec" to "l_next_free_rec"

Link: http://lkml.kernel.org/r/5e76c953-3479-1280-023c-ad05e4c75608@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-correct-annotation-from-l_next_rec-to-l_next_free_rec
+++ a/fs/ocfs2/alloc.c
@@ -3941,7 +3941,7 @@ rotate:
 	 * above.
 	 *
 	 * This leaf needs to have space, either by the empty 1st
-	 * extent record, or by virtue of an l_next_rec < l_count.
+	 * extent record, or by virtue of an l_next_free_rec < l_count.
 	 */
 	ocfs2_rotate_leaf(el, insert_rec);
 }
_

Patches currently in -mm which might be from wangyan122@huawei.com are
