From: akpm@linux-foundation.org
Subject: + slab-common-add-functions-for-kmem_cache_node-access-fix.patch
 added to -mm tree
Date: Fri, 20 Jun 2014 14:18:51 -0700
Message-ID: <53a4a53b.Y1RhKiyj/UHk649P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966845AbaFTVSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 17:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, cl@linux.com, cl@gentwo.org


The patch titled
     Subject: SLOB has no node specific management structures.
has been added to the -mm tree.  Its filename is
     slab-common-add-functions-for-kmem_cache_node-access-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-common-add-functions-for-kmem_cache_node-access-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-common-add-functions-for-kmem_cache_node-access-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: SLOB has no node specific management structures.

Do not provide the defintions for node management structures for SLOB.

Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
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
 
