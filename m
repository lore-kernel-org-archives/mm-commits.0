From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 012/118] ocfs2: remove unneeded semicolons
Date: Thu, 30 Jan 2020 22:11:36 -0800
Message-ID: <20200131061136.k3EsyuuOU%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:38 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, hulkci@huawei.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org, zhengbin13@huawei.com

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
