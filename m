From: akpm@linux-foundation.org
Subject: + parport-make-parport_cs_release-static.patch added to -mm tree
Date: Wed, 25 Jun 2008 16:46:02 -0700
Message-ID: <200806252346.m5PNk3wR000460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbYFYXq0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 19:46:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org


The patch titled
     parport: make parport_cs_release static
has been added to the -mm tree.  Its filename is
     parport-make-parport_cs_release-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

