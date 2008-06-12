From: akpm@linux-foundation.org
Subject: - ac97-add-support-for-wm9711-master-left-inv-switch.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:46 -0700
Message-ID: <200806122036.m5CKakES005362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbYFLUhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j.beisert@pengutronix.de, broonie@opensource.wolfsonmicro.com, g.liakhovetski@pengutronix.de, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ac97: add support for wm9711 master left inv switch
has been removed from the -mm tree.  Its filename was
     ac97-add-support-for-wm9711-master-left-inv-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ac97: add support for wm9711 master left inv switch
From: Juergen Beisert <j.beisert@pengutronix.de>

This patch adds support for Master Left Inv Switch on wm9711.
At least required to drive the mono speaker on the PXA270 platfrom

Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/pci/ac97/ac97_patch.c~ac97-add-support-for-wm9711-master-left-inv-switch sound/pci/ac97/ac97_patch.c
--- a/sound/pci/ac97/ac97_patch.c~ac97-add-support-for-wm9711-master-left-inv-switch
+++ a/sound/pci/ac97/ac97_patch.c
@@ -669,6 +669,7 @@ AC97_SINGLE("Mic 1 Volume", AC97_MIC, 8,
 AC97_SINGLE("Mic 2 Volume", AC97_MIC, 0, 31, 1),
 AC97_SINGLE("Mic 20dB Boost Switch", AC97_MIC, 7, 1, 0),
 
+AC97_SINGLE("Master Left Inv Switch", AC97_MASTER, 6, 1, 0),
 AC97_SINGLE("Master ZC Switch", AC97_MASTER, 7, 1, 0),
 AC97_SINGLE("Headphone ZC Switch", AC97_HEADPHONE, 7, 1, 0),
 AC97_SINGLE("Mono ZC Switch", AC97_MASTER_MONO, 7, 1, 0),
_

Patches currently in -mm which might be from j.beisert@pengutronix.de are

linux-next.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch

