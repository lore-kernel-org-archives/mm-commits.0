From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-comment-get_page_from_freelist.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:43 -0700
Message-ID: <523219ab.3R+/7A0g6yeZKa5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3ILTon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, waydi1@gmail.com

Subject: [merged] mm-page_alloc-fix-comment-get_page_from_freelist.patch removed from -mm tree
To: waydi1@gmail.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:43 -0700


The patch titled
     Subject: mm: page_alloc: fix comment get_page_from_freelist
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-comment-get_page_from_freelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeungHun Lee <waydi1@gmail.com>
Subject: mm: page_alloc: fix comment get_page_from_freelist

cpuset_zone_allowed is changed to cpuset_zone_allowed_softwall and the
comment is moved to __cpuset_node_allowed_softwall.  So fix this comment.

Signed-off-by: SeungHun Lee <waydi1@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-comment-get_page_from_freelist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-comment-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -1896,7 +1896,7 @@ get_page_from_freelist(gfp_t gfp_mask, n
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
_

Patches currently in -mm which might be from waydi1@gmail.com are

origin.patch

