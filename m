From: akpm@linux-foundation.org
Subject: + ac97-add-support-for-wm9711-master-left-inv-switch.patch added to -mm tree
Date: Sun, 08 Jun 2008 17:01:34 -0700
Message-ID: <200806090001.m5901YHn026518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbYFIABx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 20:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.beisert@pengutronix.de, broonie@opensource.wolfsonmicro.com, tiwai@suse.de


The patch titled
     ac97: add support for wm9711 master left inv switch
has been added to the -mm tree.  Its filename is
     ac97-add-support-for-wm9711-master-left-inv-switch.patch

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
Subject: ac97: add support for wm9711 master left inv switch
From: Juergen Beisert <j.beisert@pengutronix.de>

This patch adds support for Master Left Inv Switch on wm9711.
At least required to drive the mono speaker on the PXA270 platfrom

Signed-off-by: Juergen Beisert <j.beisert@pengutronix.de>
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

ac97-add-support-for-wm9711-master-left-inv-switch.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch

