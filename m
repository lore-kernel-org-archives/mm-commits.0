From: akpm@google.com
Subject: + mm-mempolicyc-quiet-sparse-noise.patch added to -mm tree
Date: Wed, 28 Sep 2011 12:20:58 -0700
Message-ID: <201109281920.p8SJKx8q027969@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:50874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1I1TVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 15:21:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, aarcange@redhat.com, hsweeten@visionengravers.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, wilsons@start.ca


The patch titled
     Subject: mm/mempolicy.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-quiet-sparse-noise.patch

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
Subject: mm/mempolicy.c: quiet sparse noise

Quiet the spares noise:

warning: symbol 'default_policy' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-quiet-sparse-noise mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-quiet-sparse-noise
+++ a/mm/mempolicy.c
@@ -111,7 +111,7 @@ enum zone_type policy_zone = 0;
 /*
  * run-time system-wide default policy => local allocation
  */
-struct mempolicy default_policy = {
+static struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
 	.mode = MPOL_PREFERRED,
 	.flags = MPOL_F_LOCAL,
_
Subject: Subject: mm/mempolicy.c: quiet sparse noise

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

