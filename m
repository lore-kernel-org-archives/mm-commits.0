From: akpm@linux-foundation.org
Subject: [merged] mm-migratec-cleanup-comment-for-migration_entry_wait.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:20 -0800
Message-ID: <20120111212820.932BC1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab2AKV2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:21 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: cleanup comment for migration_entry_wait()
has been removed from the -mm tree.  Its filename was
     mm-migratec-cleanup-comment-for-migration_entry_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/migrate.c: cleanup comment for migration_entry_wait()

migration_entry_wait() can also be called from hugetlb_fault() now. 
Remove the incorrect comment.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-cleanup-comment-for-migration_entry_wait mm/migrate.c
--- a/mm/migrate.c~mm-migratec-cleanup-comment-for-migration_entry_wait
+++ a/mm/migrate.c
@@ -181,8 +181,6 @@ static void remove_migration_ptes(struct
  * Something used the pte of a page under migration. We need to
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
- *
- * This function is called from do_swap_page().
  */
 void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long address)
_

Patches currently in -mm which might be from shhuiw@gmail.com are

origin.patch

