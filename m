From: akpm@linux-foundation.org
Subject: + ocfs2-clean-up-some-unused-func-declaration.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 16:14:41 -0700
Message-ID: <59e68ee1.Xlt2Spk7+K3h5Whz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933132AbdJQXOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, alex.chen@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: clean up some unused function declarations
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-some-unused-func-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-some-unused-func-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-some-unused-func-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 fs/ocfs2/buffer_head_io.h    |    3 ---
 fs/ocfs2/cluster/heartbeat.h |    1 -
 2 files changed, 4 deletions(-)

diff -puN fs/ocfs2/buffer_head_io.h~ocfs2-clean-up-some-unused-func-declaration fs/ocfs2/buffer_head_io.h
--- a/fs/ocfs2/buffer_head_io.h~ocfs2-clean-up-some-unused-func-declaration
+++ a/fs/ocfs2/buffer_head_io.h
@@ -28,9 +28,6 @@
 
 #include <linux/buffer_head.h>
 
-void ocfs2_end_buffer_io_sync(struct buffer_head *bh,
-			     int uptodate);
