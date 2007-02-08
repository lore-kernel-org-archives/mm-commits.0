From: akpm@linux-foundation.org
Subject: - ppc-cs4218_tdm-remove-extra-brace.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:47:45 -0800
Message-ID: <200702080947.l189ljtE010968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35694 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423154AbXBHJrw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     ppc: cs4218_tdm remove extra brace
has been removed from the -mm tree.  Its filename was
     ppc-cs4218_tdm-remove-extra-brace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppc: cs4218_tdm remove extra brace
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/8xx_io/cs4218_tdm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/ppc/8xx_io/cs4218_tdm.c~ppc-cs4218_tdm-remove-extra-brace arch/ppc/8xx_io/cs4218_tdm.c
--- a/arch/ppc/8xx_io/cs4218_tdm.c~ppc-cs4218_tdm-remove-extra-brace
+++ a/arch/ppc/8xx_io/cs4218_tdm.c
@@ -1379,7 +1379,6 @@ static void cs_nosound(unsigned long xx)
 }
 
 static DEFINE_TIMER(beep_timer, cs_nosound, 0, 0);
-};
 
 static void cs_mksound(unsigned int hz, unsigned int ticks)
 {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-scsi-misc.patch
