From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-slabh-fix-a-broken-cross-reference.patch added
 to -mm tree
Date: Wed, 08 Apr 2020 17:34:25 -0700
Message-ID: <20200409003425.9o4vh7qsR%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgDIAe0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:34:26 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, corbet@lwn.net, iamjoonsoo.kim@lge.com, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: docs: mm: slab.h: fix a broken cross-reference
has been added to the -mm tree.  Its filename is
     docs-mm-slabh-fix-a-broken-cross-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-mm-slabh-fix-a-broken-cross-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-mm-slabh-fix-a-broken-cross-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: docs: mm: slab.h: fix a broken cross-reference

There is a typo at the cross-reference link, causing this warning:

	./include/linux/slab.h:11: WARNING: undefined label: memory-allocation (if the link has no caption the label must precede a section header)

Link: http://lkml.kernel.org/r/0aeac24235d356ebd935d11e147dcc6edbb6465c.1586359676.git.mchehab+huawei@kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/slab.h~docs-mm-slabh-fix-a-broken-cross-reference
+++ a/include/linux/slab.h
@@ -501,7 +501,7 @@ static __always_inline void *kmalloc_lar
  * :ref:`Documentation/core-api/mm-api.rst <mm-api-gfp-flags>`
  *
  * The recommended usage of the @flags is described at
- * :ref:`Documentation/core-api/memory-allocation.rst <memory-allocation>`
+ * :ref:`Documentation/core-api/memory-allocation.rst <memory_allocation>`
  *
  * Below is a brief outline of the most useful GFP flags
  *
_

Patches currently in -mm which might be from mchehab+huawei@kernel.org are

docs-mm-slabh-fix-a-broken-cross-reference.patch
