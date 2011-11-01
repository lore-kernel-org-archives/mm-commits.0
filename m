From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-quiet-sparse-noise.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:43 -0700
Message-ID: <201111012111.pA1LBhuF012323@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15945 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, aarcange@redhat.com, hsweeten@visionengravers.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
ceph-mds_clientc-quiet-sparse-noise.patch
mm-page_cgroupc-quiet-sparse-noise.patch

