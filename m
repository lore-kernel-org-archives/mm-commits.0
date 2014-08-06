From: akpm@linux-foundation.org
Subject: [folded-merged]
 slab-common-add-functions-for-kmem_cache_node-access-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:42:12 -0700
Message-ID: <53e2af44.OqHCNmywPlrn87uU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:63675 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaHFWmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:42:13 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so436638qgd.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:42:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, fengguang.wu@intel.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: SLOB has no node specific management structures.
has been removed from the -mm tree.  Its filename was
     slab-common-add-functions-for-kmem_cache_node-access-fix.patch

This patch was dropped because it was folded into slab-common-add-functions-for-kmem_cache_node-access.patch

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: SLOB has no node specific management structures.

Do not provide the defintions for node management structures for SLOB.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access-fix mm/slab.h
--- a/mm/slab.h~slab-common-add-functions-for-kmem_cache_node-access-fix
+++ a/mm/slab.h
@@ -262,7 +262,7 @@ static inline struct kmem_cache *cache_f
 }
 #endif
 
