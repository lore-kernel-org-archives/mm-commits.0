From: akpm@osdl.org
Subject: - h8300-stray-bracket-fix.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:52 -0800
Message-ID: <200612072258.kB7MwqV4029438@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163665AbWLGW7D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300 stray bracket fix
has been removed from the -mm tree.  Its filename was
     h8300-stray-bracket-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: h8300 stray bracket fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/h8300/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/kernel/setup.c~h8300-stray-bracket-fix arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~h8300-stray-bracket-fix
+++ a/arch/h8300/kernel/setup.c
@@ -116,7 +116,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #else
 	if ((memory_end < CONFIG_BLKDEV_RESERVE_ADDRESS) && 
-	    (memory_end > CONFIG_BLKDEV_RESERVE_ADDRESS)
+	    (memory_end > CONFIG_BLKDEV_RESERVE_ADDRESS))
 	    /* overlap userarea */
 	    memory_end = CONFIG_BLKDEV_RESERVE_ADDRESS; 
 #endif
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch
video-cyberfb-broken-macro-removal.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch

