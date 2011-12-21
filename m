From: akpm@linux-foundation.org
Subject: + mm-migratec-cleanup-comment-for-migration_entry_wait.patch added to -mm tree
Date: Wed, 21 Dec 2011 12:14:24 -0800
Message-ID: <20111221201424.8F4A410004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:39642 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab1LUUOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 15:14:25 -0500
Received: by ggnv2 with SMTP id v2so986924ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 12:14:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shhuiw@gmail.com, minchan@kernel.org


The patch titled
     Subject: mm/migrate.c: cleanup comment for migration_entry_wait()
has been added to the -mm tree.  Its filename is
     mm-migratec-cleanup-comment-for-migration_entry_wait.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: mm/migrate.c: cleanup comment for migration_entry_wait()

Patches currently in -mm which might be from shhuiw@gmail.com are

linux-next.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mm-migratec-cleanup-comment-for-migration_entry_wait.patch

