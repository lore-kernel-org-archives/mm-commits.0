From: akpm@linux-foundation.org
Subject: [merged] aoe-cleanup-correct-comment-for-aoetgt-nout.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:53 -0800
Message-ID: <20121218201054.14FAE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62503 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:56 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so63626wey.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: cleanup: correct comment for aoetgt nout
has been removed from the -mm tree.  Its filename was
     aoe-cleanup-correct-comment-for-aoetgt-nout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: cleanup: correct comment for aoetgt nout

A misplaced comment was attached to the nout member of the aoetgt.  This
change corrects the comment.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-cleanup-correct-comment-for-aoetgt-nout drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-cleanup-correct-comment-for-aoetgt-nout
+++ a/drivers/block/aoe/aoe.h
@@ -133,7 +133,7 @@ struct aoetgt {
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
-	ushort nout;		/* value of nout when skb was sent */
+	ushort nout;		/* number of AoE commands outstanding */
 	ushort maxout;		/* current value for max outstanding */
 	ushort next_cwnd;	/* incr maxout after decrementing to zero */
 	ushort ssthresh;	/* slow start threshold */
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

