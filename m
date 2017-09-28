From: akpm@linux-foundation.org
Subject: +
 ocfs2-remove-unused-function-ocfs2_publish_get_mount_state.patch added to
 -mm tree
Date: Thu, 28 Sep 2017 13:49:26 -0700
Message-ID: <59cd6056.vjPZSUDMOx2Qhuf2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdI1Ut1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 16:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unused declaration ocfs2_publish_get_mount_state()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unused-function-ocfs2_publish_get_mount_state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unused-function-ocfs2_publish_get_mount_state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unused-function-ocfs2_publish_get_mount_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: remove unused declaration ocfs2_publish_get_mount_state()

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4D0743232@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/super.h~ocfs2-remove-unused-function-ocfs2_publish_get_mount_state fs/ocfs2/super.h
--- a/fs/ocfs2/super.h~ocfs2-remove-unused-function-ocfs2_publish_get_mount_state
+++ a/fs/ocfs2/super.h
@@ -26,9 +26,6 @@
 #ifndef OCFS2_SUPER_H
 #define OCFS2_SUPER_H
 
-int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
-				  int node_num);
