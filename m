From: akpm@linux-foundation.org
Subject: + mm-zswap-fix-trivial-typo-and-arrange-indentation.patch added
 to -mm tree
Date: Wed, 12 Feb 2014 14:20:50 -0800
Message-ID: <52fbf3c2.9M2yk27bpAR+O/50%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBLWUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 17:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, sj38.park@gmail.com

Subject: + mm-zswap-fix-trivial-typo-and-arrange-indentation.patch added to -mm tree
To: sj38.park@gmail.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 14:20:50 -0800


The patch titled
     Subject: mm/zswap.c: fix trivial typo and arrange indentation
has been added to the -mm tree.  Its filename is
     mm-zswap-fix-trivial-typo-and-arrange-indentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-fix-trivial-typo-and-arrange-indentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
linux-next.patch

