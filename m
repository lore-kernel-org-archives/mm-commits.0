From: akpm@linux-foundation.org
Subject: [folded-merged] mm-highmem-remove-page_address_pool-list-v2.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:42:06 -0800
Message-ID: <20121211234207.60F9A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:65149 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2LKXmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:42:10 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so2815lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:42:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-highmem-remove-page_address_pool-list-v2
has been removed from the -mm tree.  Its filename was
     mm-highmem-remove-page_address_pool-list-v2.patch

This patch was dropped because it was folded into mm-highmem-remove-page_address_pool-list.patch

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

mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
avr32-kconfig-remove-have_arch_bootmem.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch

