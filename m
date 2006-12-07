From: akpm@osdl.org
Subject: - i2lib-unused-variable-cleanup.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:13 -0800
Message-ID: <200612072304.kB7N4D7Y030026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52016 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163838AbWLGXER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     i2lib unused variable cleanup
has been removed from the -mm tree.  Its filename was
     i2lib-unused-variable-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2lib unused variable cleanup
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

In file included from drivers/char/ip2/ip2main.c:285:
drivers/char/ip2/i2lib.c: In function `i2Output':
drivers/char/ip2/i2lib.c:1019: warning: unused variable `rc'

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ip2/i2lib.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/ip2/i2lib.c~i2lib-unused-variable-cleanup drivers/char/ip2/i2lib.c
--- a/drivers/char/ip2/i2lib.c~i2lib-unused-variable-cleanup
+++ a/drivers/char/ip2/i2lib.c
@@ -1016,7 +1016,6 @@ i2Output(i2ChanStrPtr pCh, const char *p
 	unsigned short channel;
 	unsigned short stuffIndex;
 	unsigned long flags;
-	int rc = 0;
 
 	int bailout = 10;
 
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

