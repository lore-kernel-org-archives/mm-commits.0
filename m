From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:12:29 -0700
Message-ID: <5344663d.I6tiQ+L5lMXX70sb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbaDHVMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, sj38.park@gmail.com

Subject: [merged] mm-zswap-fix-trivial-typo-and-arrange-indentation.patch removed from -mm tree
To: sj38.park@gmail.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:12:29 -0700


The patch titled
     Subject: mm/zswap.c: fix trivial typo and arrange indentation
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-trivial-typo-and-arrange-indentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/zswap.c: fix trivial typo and arrange indentation

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/zswap.c~mm-zswap-fix-trivial-typo-and-arrange-indentation mm/zswap.c
--- a/mm/zswap.c~mm-zswap-fix-trivial-typo-and-arrange-indentation
+++ a/mm/zswap.c
@@ -160,14 +160,14 @@ static void zswap_comp_exit(void)
  * rbnode - links the entry into red-black tree for the appropriate swap type
  * refcount - the number of outstanding reference to the entry. This is needed
  *            to protect against premature freeing of the entry by code
- *            concurent calls to load, invalidate, and writeback.  The lock
+ *            concurrent calls to load, invalidate, and writeback.  The lock
  *            for the zswap_tree structure that contains the entry must
  *            be held while changing the refcount.  Since the lock must
  *            be held, there is no reason to also make refcount atomic.
  * offset - the swap offset for the entry.  Index into the red-black tree.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * length - the length in bytes of the compressed page data.  Needed during
- *           decompression
+ *          decompression
  */
 struct zswap_entry {
 	struct rb_node rbnode;
_

Patches currently in -mm which might be from sj38.park@gmail.com are

origin.patch

