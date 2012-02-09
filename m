From: akpm@linux-foundation.org
Subject: + mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch added to -mm tree
Date: Thu, 09 Feb 2012 14:28:46 -0800
Message-ID: <20120209222846.96E1CA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38100 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2BIW2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 17:28:48 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so71855eek.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 14:28:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gilad@benyossef.com


The patch titled
     Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9
has been added to the -mm tree.  Its filename is
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9
+++ a/mm/page_alloc.c
@@ -1188,7 +1188,8 @@ void drain_all_pages(void)
 	struct per_cpu_pageset *pcp;
 	struct zone *zone;
 
-	/* Allocate in the BSS so we wont require allocation in
+	/*
+	 * Allocate in the BSS so we wont require allocation in
 	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
 	 */
 	static cpumask_t cpus_with_pcps;
_
Subject: Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
arm-move-arm-over-to-generic-on_each_cpu_mask.patch
tile-move-tile-to-use-generic-on_each_cpu_mask.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-update.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

