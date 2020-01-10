From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fix-2.patch removed from -mm tree
Date: Fri, 10 Jan 2020 12:35:20 -0800
Message-ID: <20200110203520.tdNaK_BNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgAJUfV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Jan 2020 15:35:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     linux-next-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c~linux-next-fix-2
+++ a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -767,13 +767,6 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle == child_handle)
 		return 0;
 
-	if (!p->child_handle) {
-		/* This is an invisible FIFO replacing the original Qdisc.
-		 * Ignore it--the original Qdisc's destroy will follow.
-		 */
-		return 0;
-	}
