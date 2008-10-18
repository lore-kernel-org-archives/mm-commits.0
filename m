From: akpm@linux-foundation.org
Subject: - cirrusfb-remove-information-about-memory-size-during-mode-change.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:08 -0700
Message-ID: <200810182317.m9INH8As029027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYJRXRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: remove information about memory size during mode change
has been removed from the -mm tree.  Its filename was
     cirrusfb-remove-information-about-memory-size-during-mode-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: remove information about memory size during mode change
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove information about memory size displayed twice each time a display
mode change.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-information-about-memory-size-during-mode-change drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-information-about-memory-size-during-mode-change
+++ a/drivers/video/cirrusfb.c
@@ -1949,8 +1949,6 @@ static void init_vgachip(struct fb_info 
 	/* misc... */
 	WHDR(cinfo, 0);	/* Hidden DAC register: - */
 
-	printk(KERN_DEBUG "cirrusfb: This board has %ld bytes of DRAM memory\n",
-		info->screen_size);
 	DPRINTK("EXIT\n");
 	return;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

