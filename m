From: akpm@linux-foundation.org
Subject: [folded] mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:32:17 -0700
Message-ID: <20120328213217.96CDEA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44257 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1VcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:32:19 -0400
Received: by wgbdt11 with SMTP id dt11so82050wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:32:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gilad@benyossef.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9
has been removed from the -mm tree.  Its filename was
     mm-only-ipi-cpus-to-drain-local-pages-if-they-exist-v9.patch

This patch was dropped because it was folded into mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from gilad@benyossef.com are

smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
fs-only-send-ipi-to-invalidate-lru-bh-when-needed.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

