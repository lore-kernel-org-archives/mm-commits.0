From: akpm@linux-foundation.org
Subject: [merged]
 ipc-mqueuec-fixed-a-brace-coding-style-issue.patch removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:40 -0700
Message-ID: <20200408020240.XDMesRrlg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHCCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, somalaswaraj@gmail.com


The patch titled
     Subject: ipc/mqueue.c: fix a brace coding style issue
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-fixed-a-brace-coding-style-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Somala Swaraj <somalaswaraj@gmail.com>
Subject: ipc/mqueue.c: fix a brace coding style issue

Link: http://lkml.kernel.org/r/20200301135530.18340-1-somalaswaraj@gmail.com
Signed-off-by: somala swaraj <somalaswaraj@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueuec-fixed-a-brace-coding-style-issue
+++ a/ipc/mqueue.c
@@ -239,11 +239,10 @@ static inline void msg_tree_erase(struct
 		info->msg_tree_rightmost = rb_prev(node);
 
 	rb_erase(node, &info->msg_tree);
-	if (info->node_cache) {
+	if (info->node_cache)
 		kfree(leaf);
-	} else {
+	else
 		info->node_cache = leaf;
-	}
 }
 
 static inline struct msg_msg *msg_get(struct mqueue_inode_info *info)
_

Patches currently in -mm which might be from somalaswaraj@gmail.com are
