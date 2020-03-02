From: akpm@linux-foundation.org
Subject: + ipc-mqueuec-fixed-a-brace-coding-style-issue.patch
 added to -mm tree
Date: Mon, 02 Mar 2020 14:45:16 -0800
Message-ID: <20200302224516.dvrGUblha%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgCBWpR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:45:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, somalaswaraj@gmail.com


The patch titled
     Subject: ipc/mqueue.c: fix a brace coding style issue
has been added to the -mm tree.  Its filename is
     ipc-mqueuec-fixed-a-brace-coding-style-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-mqueuec-fixed-a-brace-coding-style-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-mqueuec-fixed-a-brace-coding-style-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-mqueuec-fixed-a-brace-coding-style-issue.patch
