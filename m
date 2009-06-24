From: akpm@linux-foundation.org
Subject: [merged] h8-300-fix-incorrect-select-directives-in-arch-h8300-kconfigcpu.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:10:43 -0700
Message-ID: <200906241910.n5OJAhN9010952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbZFXTK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8/300: fix incorrect "select" directives in arch/h8300/Kconfig.cpu.
has been removed from the -mm tree.  Its filename was
     h8-300-fix-incorrect-select-directives-in-arch-h8300-kconfigcpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8/300: fix incorrect "select" directives in arch/h8300/Kconfig.cpu.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Fix the incorrect "select" directives by dropping the "CONFIG_"
prefixes, and correcting the typo "H8S2768" to "H8S2678".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig.cpu |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/h8300/Kconfig.cpu~h8-300-fix-incorrect-select-directives-in-arch-h8300-kconfigcpu arch/h8300/Kconfig.cpu
--- a/arch/h8300/Kconfig.cpu~h8-300-fix-incorrect-select-directives-in-arch-h8300-kconfigcpu
+++ a/arch/h8300/Kconfig.cpu
@@ -13,7 +13,7 @@ config H8300H_GENERIC
 
 config H8300H_AKI3068NET
 	bool "AE-3068/69"
-	select CONFIG_H83068
+	select H83068
 	help
 	  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
 	  More Information. (Japanese Only)
@@ -24,7 +24,7 @@ config H8300H_AKI3068NET
 
 config H8300H_H8MAX
 	bool "H8MAX"
-	select CONFIG_H83068
+	select H83068
 	help
 	  H8MAX Evaluation Board Support
 	  More Information. (Japanese Only)
@@ -32,7 +32,7 @@ config H8300H_H8MAX
 
 config H8300H_SIM
 	bool "H8/300H Simulator"
-	select CONFIG_H83007
+	select H83007
 	help
 	  GDB Simulator Support
 	  More Information.
@@ -45,7 +45,7 @@ config H8S_GENERIC
 
 config H8S_EDOSK2674
 	bool "EDOSK-2674"
-	select CONFIG_H8S2768
+	select H8S2678
 	help
 	  Renesas EDOSK-2674 Evaluation Board Support
 	  More Information.
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch

