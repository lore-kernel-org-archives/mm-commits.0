From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 011/155] ocfs2: correct annotation from
 "l_next_rec" to "l_next_free_rec"
Date: Wed, 01 Apr 2020 21:03:38 -0700
Message-ID: <20200402040338.doJcZjhic%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:40 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org, wangyan122@huawei.com

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
