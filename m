From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-replace-if-bug-by-bug_on.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:19:12 -0700
Message-ID: <55355130.g/rd9cjeWGqnxvr6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbDTTMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: replace if/BUG by BUG_ON
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-replace-if-bug-by-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: replace if/BUG by BUG_ON

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bfind.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/hfsplus/bfind.c~fs-hfsplus-replace-if-bug-by-bug_on fs/hfsplus/bfind.c
--- a/fs/hfsplus/bfind.c~fs-hfsplus-replace-if-bug-by-bug_on
+++ a/fs/hfsplus/bfind.c
@@ -118,9 +118,7 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	int b, e;
 	int res;
 
-	if (!rec_found)
-		BUG();
