From: akpm@linux-foundation.org
Subject: - parport-make-parport_cs_release-static.patch removed from -mm tree
Date: Thu, 26 Jun 2008 02:54:23 -0700
Message-ID: <200806260954.m5Q9sNOE021583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYFZJyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jun 2008 05:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, mm-commits@vger.kernel.org


The patch titled
     parport: make parport_cs_release static
has been removed from the -mm tree.  Its filename was
     parport-make-parport_cs_release-static.patch

This patch was dropped because it was a dupe

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport: make parport_cs_release static
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_cs.c~parport-make-parport_cs_release-static drivers/parport/parport_cs.c
--- a/drivers/parport/parport_cs.c~parport-make-parport_cs_release-static
+++ a/drivers/parport/parport_cs.c
@@ -235,7 +235,7 @@ failed:
     
 ======================================================================*/
 
-void parport_cs_release(struct pcmcia_device *link)
+static void parport_cs_release(struct pcmcia_device *link)
 {
 	parport_info_t *info = link->priv;
 
_

Patches currently in -mm which might be from andre@bitwigglers.org are

parport-remove-superfluous-local-variable.patch
parport-make-parport_cs_release-static.patch

