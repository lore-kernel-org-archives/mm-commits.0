From: akpm@linux-foundation.org
Subject: + mm-migrate-fix-comment-typo-syncronous-synchronous.patch added to -mm tree
Date: Thu, 21 Mar 2013 14:43:24 -0700
Message-ID: <20130321214324.69B645A4173@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41953 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3CUVnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 17:43:25 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so306666vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 14:43:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com


The patch titled
     Subject: mm/migrate: fix comment typo syncronous->synchronous
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-comment-typo-syncronous-synchronous.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
mm-migrate-fix-comment-typo-syncronous-synchronous.patch

