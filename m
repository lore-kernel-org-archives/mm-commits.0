From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-unneeded-semicolon.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:16:57 -0800
Message-ID: <20200131231657.DWPhyyJGw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, hulkci@huawei.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, zhengbin13@huawei.com


The patch titled
     Subject: ocfs2: remove unneeded semicolons
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zhengbin <zhengbin13@huawei.com>
Subject: ocfs2: remove unneeded semicolons

Fixes coccicheck warnings:

fs/ocfs2/cluster/quorum.c:76:2-3: Unneeded semicolon
fs/ocfs2/dlmglue.c:573:2-3: Unneeded semicolon

Link: http://lkml.kernel.org/r/6ee3aa16-9078-30b1-df3f-22064950bd98@linux.alibaba.com
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    2 +-
 fs/ocfs2/dlmglue.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/quorum.c~ocfs2-remove-unneeded-semicolon
+++ a/fs/ocfs2/cluster/quorum.c
@@ -73,7 +73,7 @@ static void o2quo_fence_self(void)
 		       "system by restarting ***\n");
 		emergency_restart();
 		break;
-	};
+	}
 }
 
 /* Indicate that a timeout occurred on a heartbeat region write. The
--- a/fs/ocfs2/dlmglue.c~ocfs2-remove-unneeded-semicolon
+++ a/fs/ocfs2/dlmglue.c
@@ -570,7 +570,7 @@ void ocfs2_inode_lock_res_init(struct oc
 			mlog_bug_on_msg(1, "type: %d\n", type);
 			ops = NULL; /* thanks, gcc */
 			break;
-	};
+	}
 
 	ocfs2_build_lock_name(type, OCFS2_I(inode)->ip_blkno,
 			      generation, res->l_name);
_

Patches currently in -mm which might be from zhengbin13@huawei.com are
