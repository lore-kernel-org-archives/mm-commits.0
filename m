From: akpm@linux-foundation.org
Subject: [folded] printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:35:55 -0700
Message-ID: <200909222135.n8MLZtuM018156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbZIVVgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix 2
has been removed from the -mm tree.  Its filename was
     printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch

This patch was dropped because it was folded into printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix 2
From: Dave Young <hidave.darkstar@gmail.com>

use pr_debug for debug printk.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2 kernel/printk.c
--- a/kernel/printk.c~printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2
+++ a/kernel/printk.c
@@ -219,7 +219,7 @@ static int __init boot_delay_setup(char 
 	if (boot_delay > 10 * 1000)
 		boot_delay = 0;
 
-	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
 		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
 	return 1;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch

