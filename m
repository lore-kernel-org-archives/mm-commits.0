From: akpm@linux-foundation.org
Subject: [merged] cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:26:07 -0800
Message-ID: <200912182026.nBIKQ75b016440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932845AbZLRU0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dilinger@collabora.co.uk, mm-commits@vger.kernel.org


The patch titled
     cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on CS5535_MFGPT
has been removed from the -mm tree.  Its filename was
     cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535: CS5535_MFGPT_DEFAULT_IRQ should depend on CS5535_MFGPT
From: Geert Uytterhoeven <geert@linux-m68k.org>

It doesn't make much sense to have CS5535_MFGPT_DEFAULT_IRQ show up in
configs that cannot have CS5535_MFGPT.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~cs5535-cs5535_mfgpt_default_irq-should-depend-on-cs5535_mfgpt
+++ a/drivers/misc/Kconfig
@@ -203,6 +203,7 @@ config CS5535_MFGPT
 
 config CS5535_MFGPT_DEFAULT_IRQ
 	int
+	depends on CS5535_MFGPT
 	default 7
 	help
 	  MFGPTs on the CS5535 require an interrupt.  The selected IRQ
_

Patches currently in -mm which might be from geert@linux-m68k.org are

revert-fbdev-atafb-add-palette-register-check.patch
linux-next.patch

