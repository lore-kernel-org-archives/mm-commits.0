From: akpm@linux-foundation.org
Subject: [merged] chipsfb-remove-redundant-assignment.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:11 -0700
Message-ID: <200906171839.n5HIdBkP005268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760833AbZFQSj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     chipsfb: remove redundant assignment
has been removed from the -mm tree.  Its filename was
     chipsfb-remove-redundant-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: chipsfb: remove redundant assignment
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The removed assignment is done inside the framebuffer_alloc() earlier.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/chipsfb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/chipsfb.c~chipsfb-remove-redundant-assignment drivers/video/chipsfb.c
--- a/drivers/video/chipsfb.c~chipsfb-remove-redundant-assignment
+++ a/drivers/video/chipsfb.c
@@ -414,7 +414,6 @@ chipsfb_pci_init(struct pci_dev *dp, con
 	}
 
 	pci_set_drvdata(dp, p);
-	p->device = &dp->dev;
 
 	init_chips(p, addr);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

