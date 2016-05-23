From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-o2hb-add-some-user-debug-log-v2.patch
 removed from -mm tree
Date: Mon, 23 May 2016 14:37:48 -0700
Message-ID: <5743782c.PAiKg/bfnqo3C3w1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbcEWVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-o2hb-add-some-user-debug-log-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-o2hb-add-some-user-debug-log-v2.patch

This patch was dropped because it was folded into ocfs2-o2hb-add-some-user-debug-log.patch

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2-o2hb-add-some-user-debug-log-v2

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-some-user-debug-log-v2 fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-some-user-debug-log-v2
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -468,7 +468,7 @@ static int o2hb_nego_timeout_handler(str
 static int o2hb_nego_approve_handler(struct o2net_msg *msg, u32 len, void *data,
 				void **ret_data)
 {
-	struct o2hb_region *reg = (struct o2hb_region *)data;
+	struct o2hb_region *reg = data;
 
 	printk(KERN_NOTICE "o2hb: negotiate timeout approved by master node on region %s (%s).\n",
 		config_item_name(&reg->hr_item), reg->hr_dev_name);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

