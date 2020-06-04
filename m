From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 064/127] mm/slub: fix a typo in comment
 "disambiguiation"->"disambiguation"
Date: Thu, 04 Jun 2020 16:49:34 -0700
Message-ID: <20200604234934.c8KQwHcEQ%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgFDXtf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:35 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Ethon Paul <ethp@qq.com>
Subject: mm/slub: fix a typo in comment "disambiguiation"->"disambiguation"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200411002247.14468-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation
+++ a/mm/slub.c
@@ -2013,7 +2013,7 @@ static void *get_partial(struct kmem_cac
 
 #ifdef CONFIG_PREEMPTION
 /*
- * Calculate the next globally unique transaction for disambiguiation
+ * Calculate the next globally unique transaction for disambiguation
  * during cmpxchg. The transactions start with the cpu number and are then
  * incremented by CONFIG_NR_CPUS.
  */
_
