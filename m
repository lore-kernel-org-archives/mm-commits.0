From: akpm@linux-foundation.org
Subject: + hamradio-remove-unused-variable.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:45:33 -0700
Message-ID: <200807010545.m615jX6M011348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbYGAFqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, jeff@garzik.org


The patch titled
     hamradio: remove unused variable
has been added to the -mm tree.  Its filename is
     hamradio-remove-unused-variable.patch

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
