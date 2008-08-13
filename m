From: akpm@linux-foundation.org
Subject: - do_migrate_pages-remove-unused-variable.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:45 -0700
Message-ID: <200808130852.m7D8qjNU008253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYHMIxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, cl@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     do_migrate_pages(): remove unused variable
has been removed from the -mm tree.  Its filename was
     do_migrate_pages-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch

