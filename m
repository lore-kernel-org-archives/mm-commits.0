From: akpm@linux-foundation.org
Subject: - arm-lubbock-fix-compilation.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:53 -0700
Message-ID: <200805092146.m49LkrqZ027157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbYEIVra (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm-lubbock: fix compilation
has been removed from the -mm tree.  Its filename was
     arm-lubbock-fix-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm-lubbock: fix compilation
From: Alexey Dobriyan <adobriyan@gmail.com>

arch/arm/mach-pxa/lubbock.c:399: error: expected '}' before ';' token

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/lubbock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-pxa/lubbock.c~arm-lubbock-fix-compilation arch/arm/mach-pxa/lubbock.c
--- a/arch/arm/mach-pxa/lubbock.c~arm-lubbock-fix-compilation
+++ a/arch/arm/mach-pxa/lubbock.c
@@ -396,7 +396,7 @@ static struct pxafb_mach_info sharp_lm8v
 	.cmap_inverse	= 0,
 	.cmap_static	= 0,
 	.lcd_conn	= LCD_COLOR_DSTN_16BPP | LCD_PCLK_EDGE_FALL |
-			  LCD_AC_BIAS_FREQ(255);
+			  LCD_AC_BIAS_FREQ(255),
 };
 
 #define	MMC_POLL_RATE		msecs_to_jiffies(1000)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
cifs-switch-to-seq_files.patch
jfs-switch-to-seq_files.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch
ext4-switch-to-seq_files.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

