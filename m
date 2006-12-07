From: akpm@osdl.org
Subject: - char-ip2-remove-broken-macro.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:31 -0800
Message-ID: <200612072315.kB7NFVE7030734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53542 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163886AbWLGXPi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     char: ip2 remove broken macro
has been removed from the -mm tree.  Its filename was
     char-ip2-remove-broken-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: char: ip2 remove broken macro
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This macro is broken and unused so why not remove it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ip2/i2cmd.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/char/ip2/i2cmd.h~char-ip2-remove-broken-macro drivers/char/ip2/i2cmd.h
--- a/drivers/char/ip2/i2cmd.h~char-ip2-remove-broken-macro
+++ a/drivers/char/ip2/i2cmd.h
@@ -367,11 +367,6 @@ static UCHAR cc02[];
 #define CSE_NULL  3  // Replace with a null
 #define CSE_MARK  4  // Replace with a 3-character sequence (as Unix)
 
-#define  CMD_SET_REPLACEMENT(arg,ch)   \
-			(((cmdSyntaxPtr)(ct36a))->cmd[1] = (arg), \
-			(((cmdSyntaxPtr)(ct36a))->cmd[2] = (ch),  \
-			(cmdSyntaxPtr)(ct36a))
-
 #define CSE_REPLACE  0x8	// Replace the errored character with the
 							// replacement character defined here
 
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

