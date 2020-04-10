From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/35] docs: mm: slab.h: fix a broken
 cross-reference
Date: Fri, 10 Apr 2020 14:32:25 -0700
Message-ID: <20200410213225.MBzwpCFlZ%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVc0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:26 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, corbet@lwn.net, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mchehab+huawei@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

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
