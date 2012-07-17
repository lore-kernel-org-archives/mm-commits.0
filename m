From: akpm@linux-foundation.org
Subject: [merged] hfsplus-amend-debugging-print.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:48 -0700
Message-ID: <20120717200448.A3A0E1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61738 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2GQUEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so87559qab.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: amend debugging print
has been removed from the -mm tree.  Its filename was
     hfsplus-amend-debugging-print.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: amend debugging print

Print correct function name in the debugging print of the
'hfsplus_sync_fs()' function.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-amend-debugging-print fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-amend-debugging-print
+++ a/fs/hfsplus/super.c
@@ -171,7 +171,7 @@ static int hfsplus_sync_fs(struct super_
 	if (!wait)
 		return 0;
 
-	dprint(DBG_SUPER, "hfsplus_write_super\n");
+	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
 	sb->s_dirt = 0;
 
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

