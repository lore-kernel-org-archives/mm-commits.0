From: akpm@linux-foundation.org
Subject: + mm-fix-slabc-kernel-doc-warnings.patch added to -mm tree
Date: Wed, 07 Nov 2012 12:13:58 -0800
Message-ID: <20121107201358.EEE8B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55518 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2KGUOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 15:14:01 -0500
Received: by mail-ea0-f202.google.com with SMTP id q10so133643eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 12:14:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@infradead.org, cl@linux-foundation.org, mpm@selenic.com, penberg@kernel.org


The patch titled
     Subject: mm: fix slab.c kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-slabc-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix slab.c kernel-doc warnings

Fix new kernel-doc warnings in mm/slab.c:

Warning(mm/slab.c:2358): No description found for parameter 'cachep'
Warning(mm/slab.c:2358): Excess function parameter 'name' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'size' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'align' description in '__kmem_cache_create'
Warning(mm/slab.c:2358): Excess function parameter 'ctor' description in '__kmem_cache_create'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/slab.c~mm-fix-slabc-kernel-doc-warnings mm/slab.c
--- a/mm/slab.c~mm-fix-slabc-kernel-doc-warnings
+++ a/mm/slab.c
@@ -2349,11 +2349,8 @@ static int __init_refok setup_cpu_cache(
 
 /**
  * __kmem_cache_create - Create a cache.
- * @name: A string which is used in /proc/slabinfo to identify this cache.
- * @size: The size of objects to be created in this cache.
- * @align: The required alignment for the objects.
+ * @cachep: cache management descriptor
  * @flags: SLAB flags
- * @ctor: A constructor for the objects.
  *
  * Returns a ptr to the cache on success, NULL on failure.
  * Cannot be called within a int, but can be interrupted.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-fix-slabc-kernel-doc-warnings.patch

