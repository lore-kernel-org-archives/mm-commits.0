From: akpm@linux-foundation.org
Subject: + mm-vmscanc-fixed-typo.patch added to -mm tree
Date: Wed, 17 Jun 2020 18:07:33 -0700
Message-ID: <20200618010733.sA0eV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726854AbgFRBHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, david@redhat.com, spacct.spacct@gmail.com


The patch titled
     Subject: mm/vmscan.c: fix typo
has been added to the -mm tree.  Its filename is
     mm-vmscanc-fixed-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-fixed-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-fixed-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: dylan-meiners <spacct.spacct@gmail.com>
Subject: mm/vmscan.c: fix typo

Change "optizimation" to "optimization".

Link: http://lkml.kernel.org/r/20200609185144.10049-1-spacct.spacct@gmail.com
Signed-off-by: dylan-meiners <spacct.spacct@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fixed-typo
+++ a/mm/vmscan.c
@@ -915,7 +915,7 @@ static int __remove_mapping(struct addre
 		 * order to detect refaults, thus thrashing, later on.
 		 *
 		 * But don't store shadows in an address space that is
-		 * already exiting.  This is not just an optizimation,
+		 * already exiting.  This is not just an optimization,
 		 * inode reclaim needs to empty out the radix tree or
 		 * the nodes are lost.  Don't plant shadows behind its
 		 * back.
_

Patches currently in -mm which might be from spacct.spacct@gmail.com are

mm-vmscanc-fixed-typo.patch
