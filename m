From: akpm@linux-foundation.org
Subject: [merged] mm-page_cgroupc-quiet-sparse-noise.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:30 -0800
Message-ID: <201111072027.pA7KRUNM027045@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1KGU1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, bsingharora@gmail.com, hsweeten@visionengravers.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, paul@paulmenage.or


The patch titled
     Subject: mm/page_cgroup.c: quiet sparse noise
has been removed from the -mm tree.  Its filename was
     mm-page_cgroupc-quiet-sparse-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: mm/page_cgroup.c: quiet sparse noise

warning: symbol 'swap_cgroup_ctrl' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~mm-page_cgroupc-quiet-sparse-noise mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroupc-quiet-sparse-noise
+++ a/mm/page_cgroup.c
@@ -360,7 +360,7 @@ struct swap_cgroup_ctrl {
 	spinlock_t	lock;
 };
 
-struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
+static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
 struct swap_cgroup {
 	unsigned short		id;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch

