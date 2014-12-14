From: akpm@linux-foundation.org
Subject: [merged] befs-remove-dead-code.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:12 -0800
Message-ID: <548d0d68.F4yD2GAzA3rX9aju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaLNEJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: remove dead code
has been removed from the -mm tree.  Its filename was
     befs-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: befs: remove dead code

Coverity id: 1042674

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/befs/linuxvfs.c~befs-remove-dead-code fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-remove-dead-code
+++ a/fs/befs/linuxvfs.c
@@ -269,10 +269,6 @@ more:
 	}
 	ctx->pos++;
 	goto more;
-
-	befs_debug(sb, "<--- %s pos %lld", __func__, ctx->pos);
