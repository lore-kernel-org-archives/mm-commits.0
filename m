From: akpm@linux-foundation.org
Subject: - char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:39 -0700
Message-ID: <200705090257.l492vd0T010214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032754AbXEIC5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, mark cyy_init_card as __devinit, not __init
has been removed from the -mm tree.  Its filename was
     char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, mark cyy_init_card as __devinit, not __init
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-mark-cyy_init_card-as-__devinit-not-__init drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-mark-cyy_init_card-as-__devinit-not-__init
+++ a/drivers/char/cyclades.c
@@ -4651,8 +4651,8 @@ static void __devinit cy_init_card(struc
 
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
-static unsigned short __init
-cyy_init_card(void __iomem * true_base_addr, int index)
+static unsigned short __devinit cyy_init_card(void __iomem *true_base_addr,
+		int index)
 {
 	unsigned int chip_number;
 	void __iomem *base_addr;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
