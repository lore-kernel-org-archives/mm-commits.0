From: akpm@linux-foundation.org
Subject: - ppc-logical-bitand-typo-in-powerpc-boot-4xxc.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:48:23 -0800
Message-ID: <200801290148.m0T1mNcW027347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbYA2BtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:49:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, benh@kernel.crashing.org, galak@gate.crashing.org, jwboyer@linux.vnet.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppc: logical/bitand typo in powerpc/boot/4xx.c
has been removed from the -mm tree.  Its filename was
     ppc-logical-bitand-typo-in-powerpc-boot-4xxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ppc: logical/bitand typo in powerpc/boot/4xx.c
From: Roel Kluin <12o3l@tiscali.nl>

logical/bitand typo

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/4xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/boot/4xx.c~ppc-logical-bitand-typo-in-powerpc-boot-4xxc arch/powerpc/boot/4xx.c
--- a/arch/powerpc/boot/4xx.c~ppc-logical-bitand-typo-in-powerpc-boot-4xxc
+++ a/arch/powerpc/boot/4xx.c
@@ -159,7 +159,7 @@ void ibm4xx_denali_fixup_memsize(void)
 	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
 	cs = 0;
 	while (val) {
-		if (val && 0x1)
+		if (val & 0x1)
 			cs++;
 		val = val >> 1;
 	}
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-powerpc.patch
git-mips.patch
git-net.patch
m68k-balance-ioremap-and-iounmap-in-m68k-atari-hades-pcic.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
fix-and-typo-in-eicons-addinfo.patch
