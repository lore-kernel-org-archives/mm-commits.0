From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 165/166] ipc/mqueue.c: fix a brace coding style
 issue
Date: Mon, 06 Apr 2020 20:12:53 -0700
Message-ID: <20200407031253.Q2d9UZBAl%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgDGDMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:12:54 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, somalaswaraj@gmail.com, torvalds@linux-foundation.org

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
