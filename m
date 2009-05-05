From: akpm@linux-foundation.org
Subject: + chipsfb-remove-redundant-assignment.patch added to -mm tree
Date: Tue, 05 May 2009 12:51:38 -0700
Message-ID: <200905051951.n45JpcNt022567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758540AbZEETxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     chipsfb: remove redundant assignment
has been added to the -mm tree.  Its filename is
     chipsfb-remove-redundant-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
fbdev-fix-fillrect-for-24bpp-modes.patch
fbdev-remove-makefile-reference-to-removed-driver.patch
chipsfb-remove-redundant-assignment.patch

