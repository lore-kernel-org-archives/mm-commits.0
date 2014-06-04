From: akpm@linux-foundation.org
Subject: [folded-merged] mm-get-rid-of-__gfp_kmemcg-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:22:02 -0700
Message-ID: <538f9c0a.fLgre+8vfuqgIgBa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaFDWWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, sfr@canb.auug.org.au

Subject: [folded-merged] mm-get-rid-of-__gfp_kmemcg-fix.patch removed from -mm tree
To: sfr@canb.auug.org.au,vdavydov@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:22:02 -0700


The patch titled
     Subject: mm: get rid of __GFP_KMEMCG fix
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-__gfp_kmemcg-fix.patch

This patch was dropped because it was folded into mm-get-rid-of-__gfp_kmemcg.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: get rid of __GFP_KMEMCG fix

export kmalloc_order() to modules

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg-fix
+++ a/mm/slab_common.c
@@ -593,6 +593,7 @@ void *kmalloc_order(size_t size, gfp_t f
 	kmemleak_alloc(ret, size, 1, flags);
 	return ret;
 }
+EXPORT_SYMBOL(kmalloc_order);
 
 #ifdef CONFIG_TRACING
 void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets-fix.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch

