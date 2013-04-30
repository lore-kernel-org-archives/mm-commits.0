From: akpm@linux-foundation.org
Subject: [merged] mm-migrate-fix-comment-typo-syncronous-synchronous.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:22 -0700
Message-ID: <20130430184822.6F8EA31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:35864 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3SsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:23 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so85033yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix comment typo syncronous->synchronous
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-comment-typo-syncronous-synchronous.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/migrate: fix comment typo syncronous->synchronous

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migrate-fix-comment-typo-syncronous-synchronous mm/migrate.c
--- a/mm/migrate.c~mm-migrate-fix-comment-typo-syncronous-synchronous
+++ a/mm/migrate.c
@@ -736,7 +736,7 @@ static int __unmap_and_move(struct page
 
 	if (PageWriteback(page)) {
 		/*
-		 * Only in the case of a full syncronous migration is it
+		 * Only in the case of a full synchronous migration is it
 		 * necessary to wait for PageWriteback. In the async case,
 		 * the retry loop is too short and in the sync-light case,
 		 * the overhead of stalling is too much
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch

