From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-comment-get_page_from_freelist.patch added to -mm tree
Date: Mon, 19 Aug 2013 13:31:10 -0700
Message-ID: <5212808e.uhgMieAK5XK6R4R3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3HSUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 16:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, waydi1@gmail.com

Subject: + mm-page_alloc-fix-comment-get_page_from_freelist.patch added to -mm tree
To: waydi1@gmail.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 13:31:10 -0700


The patch titled
     Subject: mm: page_alloc: fix comment get_page_from_freelist
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-comment-get_page_from_freelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-comment-get_page_from_freelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-comment-get_page_from_freelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1897,7 +1897,7 @@ get_page_from_freelist(gfp_t gfp_mask, n
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

mm-page_alloc-fix-comment-get_page_from_freelist.patch

