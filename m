From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 012/128] Documentation/vm/slub.rst:
 s/Toggle/Enable/
Date: Mon, 01 Jun 2020 21:46:00 -0700
Message-ID: <20200602044600.-k8gyUKOX%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEqB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:46:01 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/vm/slub.rst: s/Toggle/Enable/

"toggle" means to change a boolean thing's state.  This operation doesn't
do that - it sets it to "true".

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/vm/slub.rst~mm-slub-add-panic_on_error-to-the-debug-facilities-fix
+++ a/Documentation/vm/slub.rst
@@ -49,7 +49,7 @@ Possible debug options are::
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
-	A		Toggle failslab filter mark for the cache
+	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
 			caused higher minimum slab orders
 	-		Switch all debugging off (useful if the kernel is
_
