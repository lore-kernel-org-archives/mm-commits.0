From: akpm@linux-foundation.org
Subject: - smc911x-remove-duplicate-debug-printout.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:51:37 -0700
Message-ID: <200810012151.m91Lpb2b005945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbYJAVvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@igel.co.jp, jacmet@sunsite.dk, mm-commits@vger.kernel.org


The patch titled
     smc911x: remove duplicate debug printout
has been removed from the -mm tree.  Its filename was
     smc911x-remove-duplicate-debug-printout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: remove duplicate debug printout
From: Magnus Damm <damm@igel.co.jp>

Remove duplicated debug printout.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/smc911x.c~smc911x-remove-duplicate-debug-printout drivers/net/smc911x.c
--- a/drivers/net/smc911x.c~smc911x-remove-duplicate-debug-printout
+++ a/drivers/net/smc911x.c
@@ -1174,8 +1174,6 @@ static irqreturn_t smc911x_interrupt(int
 
 	spin_unlock_irqrestore(&lp->lock, flags);
 
-	DBG(3, "%s: Interrupt done (%d loops)\n", dev->name, 8-timeout);
