From: akpm@google.com
Subject: + mm-thrashc-quiet-sparse-noise.patch added to -mm tree
Date: Wed, 28 Sep 2011 12:20:52 -0700
Message-ID: <201109281920.p8SJKr1I013835@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1I1TVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 15:21:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     Subject: mm/thrash.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     mm-thrashc-quiet-sparse-noise.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: mm/thrash.c: quiet sparse noise

Quiet the following sparse noise:

warning: symbol 'swap_token_memcg' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/thrash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/thrash.c~mm-thrashc-quiet-sparse-noise mm/thrash.c
--- a/mm/thrash.c~mm-thrashc-quiet-sparse-noise
+++ a/mm/thrash.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
-struct mem_cgroup *swap_token_memcg;
+static struct mem_cgroup *swap_token_memcg;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
_
Subject: Subject: mm/thrash.c: quiet sparse noise

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
mm-memblockc-quiet-sparse-noise.patch
mm-thrashc-quiet-sparse-noise.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

