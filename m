From: akpm@linux-foundation.org
Subject: + mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch added to -mm tree
Date: Mon, 13 May 2013 14:11:59 -0700
Message-ID: <20130513211159.A6E4F5A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:59081 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3EMVMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 17:12:01 -0400
Received: by mail-ve0-f202.google.com with SMTP id 14so252029vea.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 14:12:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cody@linux.vnet.ibm.com, gilad@benyossef.com, kosaki.motohiro@gmail.com, mgorman@suse.de, penberg@kernel.org


The patch titled
     Subject: mm/page_alloc: relocate comment to be directly above code it refers to.
has been added to the -mm tree.  Its filename is
     mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: relocate comment to be directly above code it refers to.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to
+++ a/mm/page_alloc.c
@@ -3711,12 +3711,12 @@ void __ref build_all_zonelists(pg_data_t
 		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
-		/* we have to stop all cpus to guarantee there is no user
-		   of zonelist */
 #ifdef CONFIG_MEMORY_HOTPLUG
 		if (zone)
 			setup_zone_pageset(zone);
 #endif
+		/* we have to stop all cpus to guarantee there is no user
+		   of zonelist */
 		stop_machine(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch

