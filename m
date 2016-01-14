From: akpm@linux-foundation.org
Subject: [folded-merged]
 net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:29:13 -0800
Message-ID: <56982139.ykXSZBBcpSrZfczt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbcANW3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:29:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter
has been removed from the -mm tree.  Its filename was
     net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix.patch

This patch was dropped because it was folded into net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter

Fixlet for the same-named patch currently in mmots. The forward decl
is no longer necessary when the socket directly points to the memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/net/sock.h~net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix include/net/sock.h
--- a/include/net/sock.h~net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter-fix
+++ a/include/net/sock.h
@@ -229,7 +229,6 @@ struct sock_common {
 	/* public: */
 };
 
-struct cg_proto;
 /**
   *	struct sock - network layer representation of sockets
   *	@__sk_common: shared layout with inet_timewait_sock
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch

