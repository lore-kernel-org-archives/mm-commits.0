From: akpm@linux-foundation.org
Subject: [folded-merged] net-drop-tcp_memcontrolc-fix.patch removed from
 -mm tree
Date: Wed, 20 Jan 2016 14:41:10 -0800
Message-ID: <56a00d06.0P9Qu+pnKL9Oo2nP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbcATWlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hannes@cmpxchg.org, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net-drop-tcp_memcontrolc-fix
has been removed from the -mm tree.  Its filename was
     net-drop-tcp_memcontrolc-fix.patch

This patch was dropped because it was folded into net-drop-tcp_memcontrolc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net-drop-tcp_memcontrolc-fix

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~net-drop-tcp_memcontrolc-fix mm/memcontrol.c
--- a/mm/memcontrol.c~net-drop-tcp_memcontrolc-fix
+++ a/mm/memcontrol.c
@@ -4415,8 +4415,6 @@ static void mem_cgroup_css_free(struct c
 		static_branch_dec(&memcg_sockets_enabled_key);
 #endif
 
-	memcg_free_kmem(memcg);
