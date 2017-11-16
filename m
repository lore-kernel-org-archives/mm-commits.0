From: akpm@linux-foundation.org
Subject: [patch 003/131] ocfs2: remove unused declaration
 ocfs2_publish_get_mount_state()
Date: Wed, 15 Nov 2017 17:31:21 -0800
Message-ID: <20171116013121.Q-8OT52Mc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933438AbdKPBbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: remove unused declaration ocfs2_publish_get_mount_state()

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4D0743232@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: guozhonghua <guozhonghua@h3c.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>
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
