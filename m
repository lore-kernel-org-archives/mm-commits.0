From: akpm@linux-foundation.org
Subject: [merged] ocfs2-clean-up-some-unused-func-declaration.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 11:58:56 -0800
Message-ID: <20171116195856.ArncahCTe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934001AbdKPT65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:58:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: clean up some unused function declarations
has been removed from the -mm tree.  Its filename was
     ocfs2-clean-up-some-unused-func-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: clean up some unused function declarations

Link: http://lkml.kernel.org/r/59C5D7D6.9050106@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/buffer_head_io.h~ocfs2-clean-up-some-unused-func-declaration fs/ocfs2/buffer_head_io.h
--- a/fs/ocfs2/buffer_head_io.h~ocfs2-clean-up-some-unused-func-declaration
+++ a/fs/ocfs2/buffer_head_io.h
@@ -28,9 +28,6 @@
 
 #include <linux/buffer_head.h>
 
-void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
-			     int uptodate);
