From: akpm@linux-foundation.org
Subject: [merged] mm-migratec-remove-the-unused-macro-lru_to_page.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:41 -0800
Message-ID: <20120111212842.118E120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54553 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab2AKV2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:43 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44236eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, kyungmin.park@samsung.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: remove the unused macro lru_to_page
has been removed from the -mm tree.  Its filename was
     mm-migratec-remove-the-unused-macro-lru_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/migrate.c: remove the unused macro lru_to_page

lru_to_page is not used in mm/migrate.c.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-remove-the-unused-macro-lru_to_page mm/migrate.c
--- a/mm/migrate.c~mm-migratec-remove-the-unused-macro-lru_to_page
+++ a/mm/migrate.c
@@ -39,8 +39,6 @@
 
 #include "internal.h"
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
