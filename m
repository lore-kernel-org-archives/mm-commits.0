From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 01 Jun 2016 10:49:50 -0700
Message-ID: <574f203e.+AN0lEXj/vZQxc73%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbcFARtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 13:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
