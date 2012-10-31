From: akpm@linux-foundation.org
Subject: + mm-highmem-remove-page_address_pool-list-v2.patch added to -mm tree
Date: Wed, 31 Oct 2012 16:50:14 -0700
Message-ID: <20121031235015.1B80B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40230 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2JaXuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2012 19:50:16 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so231255ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Oct 2012 16:50:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm-highmem-remove-page_address_pool-list-v2
has been added to the -mm tree.  Its filename is
     mm-highmem-remove-page_address_pool-list-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm-highmem-remove-page_address_pool-list-v2

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/highmem.c~mm-highmem-remove-page_address_pool-list-v2 mm/highmem.c
--- a/mm/highmem.c~mm-highmem-remove-page_address_pool-list-v2
+++ a/mm/highmem.c
@@ -324,6 +324,7 @@ struct page_address_map {
 	void *virtual;
 	struct list_head list;
 };
+
 static struct page_address_map page_address_maps[LAST_PKMAP];
 
 /*
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

