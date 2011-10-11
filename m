From: akpm@google.com
Subject: + mm-page_cgroupc-quiet-sparse-noise.patch added to -mm tree
Date: Tue, 11 Oct 2011 14:17:04 -0700
Message-ID: <201110112117.p9BLH4th027071@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1JKVRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 17:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, bsingharora@gmail.com, hsweeten@visionengravers.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, paul@paulmenage.org


The patch titled
     Subject: mm/page_cgroup.c: quiet sparse noise
has been added to the -mm tree.  Its filename is
     mm-page_cgroupc-quiet-sparse-noise.patch

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
Subject: mm/page_cgroup.c: quiet sparse noise

warning: symbol 'swap_cgroup_ctrl' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@google.com>
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
Subject: Subject: mm/page_cgroup.c: quiet sparse noise

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
mm-page_cgroupc-quiet-sparse-noise.patch

