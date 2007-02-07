From: akpm@linux-foundation.org
Subject: - mips-dbg_io-stray-brackets-fix.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:52 -0800
Message-ID: <200702071952.l17Jqq2w025275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161442AbXBGT4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:56:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips dbg_io stray brackets fix
has been removed from the -mm tree.  Its filename was
     mips-dbg_io-stray-brackets-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips dbg_io stray brackets fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This macro is broken, and not used.  Remove it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pmc-sierra/yosemite/dbg_io.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/mips/pmc-sierra/yosemite/dbg_io.c~mips-dbg_io-stray-brackets-fix arch/mips/pmc-sierra/yosemite/dbg_io.c
--- a/arch/mips/pmc-sierra/yosemite/dbg_io.c~mips-dbg_io-stray-brackets-fix
+++ a/arch/mips/pmc-sierra/yosemite/dbg_io.c
@@ -92,9 +92,6 @@
 /*
  * Functions to READ and WRITE to serial port 1
  */
-#define	SERIAL_READ_1(ofs)		(*((volatile unsigned char*)	\
-					(TITAN_SERIAL_BASE_1 + ofs)
-
 #define	SERIAL_WRITE_1(ofs, val)	((*((volatile unsigned char*)	\
 					(TITAN_SERIAL_BASE_1 + ofs))) = val)
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa.patch
git-powerpc.patch
ppc-cs4218_tdm-remove-extra-brace.patch
git-dvb.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
