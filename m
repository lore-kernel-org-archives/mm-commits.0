From: akpm@linux-foundation.org
Subject: - hamradio-remove-unused-variable.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:16 -0700
Message-ID: <200807020747.m627lGOJ005636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980AbYGBHr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     hamradio: remove unused variable
has been removed from the -mm tree.  Its filename was
     hamradio-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hamradio: remove unused variable
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/dmascc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/net/hamradio/dmascc.c~hamradio-remove-unused-variable drivers/net/hamradio/dmascc.c
--- a/drivers/net/hamradio/dmascc.c~hamradio-remove-unused-variable
+++ a/drivers/net/hamradio/dmascc.c
@@ -1077,8 +1077,6 @@ static inline void rx_off(struct scc_pri
 
 static void start_timer(struct scc_priv *priv, int t, int r15)
 {
-	unsigned long flags;
