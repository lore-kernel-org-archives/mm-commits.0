From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:36:43 -0700
Message-ID: <5591ac5b.xfkw7EwgiBrNVnqR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2Ugo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: should remove debugfs in o2net_init() out branch
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: o2net: should remove debugfs in o2net_init() out branch

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch
+++ a/fs/ocfs2/cluster/tcp.c
@@ -2204,7 +2204,7 @@ out:
 	kfree(o2net_hand);
 	kfree(o2net_keep_req);
 	kfree(o2net_keep_resp);
