From: akpm@linux-foundation.org
Subject: [merged] docs-mm-slabh-fix-a-broken-cross-reference.patch
 removed from -mm tree
Date: Sat, 11 Apr 2020 23:44:36 -0700
Message-ID: <20200412064436._m9NQECYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGoi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, corbet@lwn.net, iamjoonsoo.kim@lge.com, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: docs: mm: slab.h: fix a broken cross-reference
has been removed from the -mm tree.  Its filename was
     docs-mm-slabh-fix-a-broken-cross-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
