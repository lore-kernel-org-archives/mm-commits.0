From: akpm@linux-foundation.org
Subject: + do_migrate_pages-remove-unused-variable.patch added to -mm tree
Date: Thu, 07 Aug 2008 16:40:25 -0700
Message-ID: <200808072340.m77NePZE011875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbYHGXk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 19:40:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, cl@linux-foundation.org


The patch titled
     do_migrate_pages(): remove unused variable
has been added to the -mm tree.  Its filename is
     do_migrate_pages-remove-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_migrate_pages(): remove unused variable
From: MinChan Kim <minchan.kim@gmail.com>

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/mempolicy.c~do_migrate_pages-remove-unused-variable mm/mempolicy.c
--- a/mm/mempolicy.c~do_migrate_pages-remove-unused-variable
+++ a/mm/mempolicy.c
@@ -803,7 +803,6 @@ static int migrate_to_node(struct mm_str
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags)
 {
-	LIST_HEAD(pagelist);
 	int busy = 0;
 	int err = 0;
 	nodemask_t tmp;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

do_migrate_pages-remove-unused-variable.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch

