From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 02 Jun 2016 10:58:23 -0700
Message-ID: <575073bf.jg6YRY8uK3Spm3yO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbcFBR6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 13:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/sfc/rx.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/net/ethernet/sfc/rx.c~linux-next-git-rejects drivers/net/ethernet/sfc/rx.c
--- a/drivers/net/ethernet/sfc/rx.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/sfc/rx.c
@@ -845,12 +845,6 @@ int efx_filter_rfs(struct net_device *ne
 	struct flow_keys fk;
 	int rc;
 
-<<<<<<< HEAD
-	if (flow_id == RPS_FLOW_ID_INVALID)
-		return -EINVAL;
