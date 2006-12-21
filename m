From: akpm@osdl.org
Subject: - alsa-kill-pxa2xx-kconfig-warning.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:37 -0800
Message-ID: <200612210036.kBL0ab7Y011213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161111AbWLUAgu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, frederik.deweerdt@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: kill pxa2xx Kconfig warning
has been removed from the -mm tree.  Its filename was
     alsa-kill-pxa2xx-kconfig-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa: kill pxa2xx Kconfig warning
From: Frederik Deweerdt <deweerdt@free.fr>

The following patch silences the following Kconfig warning:
scripts/kconfig/conf -s arch/i386/Kconfig
sound/soc/pxa/Kconfig:18:warning: 'select' used by config symbol 'SND_PXA2XX_SOC_AC97' refer to undefined symbol 'SND_AC97_BUS'

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/soc/pxa/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/pxa/Kconfig~alsa-kill-pxa2xx-kconfig-warning sound/soc/pxa/Kconfig
--- a/sound/soc/pxa/Kconfig~alsa-kill-pxa2xx-kconfig-warning
+++ a/sound/soc/pxa/Kconfig
@@ -15,7 +15,7 @@ config SND_PXA2XX_AC97
 
 config SND_PXA2XX_SOC_AC97
 	tristate
-	select SND_AC97_BUS
+	select AC97_BUS
 	select SND_SOC_AC97_BUS
 
 config SND_PXA2XX_SOC_I2S
_

Patches currently in -mm which might be from deweerdt@free.fr are

disable-init-initramfsc-updated-fix.patch

