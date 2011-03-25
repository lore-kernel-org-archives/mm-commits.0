From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unused-page-flag-bitfield-defines.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:33 -0700
Message-ID: <201103250724.p2P7ORjk025860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab1CYHYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove unused page flag bitfield defines
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-page-flag-bitfield-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove unused page flag bitfield defines
From: Johannes Weiner <hannes@cmpxchg.org>

These definitions have been unused since '4b3bde4 memcg: remove the
overhead associated with the root cgroup'.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-page-flag-bitfield-defines mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-page-flag-bitfield-defines
+++ a/mm/memcontrol.c
@@ -327,13 +327,6 @@ enum charge_type {
 	NR_CHARGE_TYPE,
 };
 
-/* only for here (for easy reading.) */
-#define PCGF_CACHE	(1UL << PCG_CACHE)
-#define PCGF_USED	(1UL << PCG_USED)
-#define PCGF_LOCK	(1UL << PCG_LOCK)
-/* Not used, but added here for completeness */
-#define PCGF_ACCT	(1UL << PCG_ACCT)
