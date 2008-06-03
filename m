From: akpm@linux-foundation.org
Subject: + powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:42:48 -0700
Message-ID: <200806032342.m53NgmKQ025924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYFCXm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, galak@kernel.crashing.org, paulus@samba.org, wim@iguana.be


The patch titled
     powerpc: 86xx: mpc8610_hpcd: add watchdog node
has been added to the -mm tree.  Its filename is
     powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: 86xx: mpc8610_hpcd: add watchdog node
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8610_hpcd.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8610_hpcd.dts~powerpc-86xx-mpc8610_hpcd-add-watchdog-node arch/powerpc/boot/dts/mpc8610_hpcd.dts
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts~powerpc-86xx-mpc8610_hpcd-add-watchdog-node
+++ a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -202,6 +202,11 @@
 			fsl,has-rstcr;
 		};
 
+		wdt@e4000 {
+			compatible = "fsl,mpc8610-wdt";
+			reg = <0xe4000 0x100>;
+		};
+
 		i2s@16000 {
 			compatible = "fsl,mpc8610-ssi";
 			cell-index = <0>;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
serial-fix-driver_name-conflicts.patch
linux-next.patch
git-leds.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
mpc83xx_wdt-add-support-for-mpc86xx-cpus.patch
mpc83xx_wdt-rename-to-mpc8xxx_wdt.patch
mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
mpc8xxx_wdt-add-support-for-mpc8xx-watchdogs.patch
powerpc-fsl_soc-remove-mpc83xx_wdt-code.patch
powerpc-86xx-mpc8610_hpcd-add-watchdog-node.patch
hgafb-fix-module-removal.patch

