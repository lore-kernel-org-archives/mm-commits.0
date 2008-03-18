From: akpm@linux-foundation.org
Subject: + git-alsa-tiwai-sound-drivers-pcsp-pcspc-build-fix.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:50:36 -0700
Message-ID: <200803180350.m2I3oat1012820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbYCRDvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, perex@perex.cz, tiwai@suse.de


The patch titled
     git-alsa-tiwai: sound/drivers/pcsp/pcsp.c build fix
has been added to the -mm tree.  Its filename is
     git-alsa-tiwai-sound-drivers-pcsp-pcspc-build-fix.patch

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
Subject: git-alsa-tiwai: sound/drivers/pcsp/pcsp.c build fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

sound/drivers/pcsp/pcsp.c: In function 'snd_pcsp_create':
sound/drivers/pcsp/pcsp.c:54: error: 'loops_per_jiffy' undeclared (first use in this function)
sound/drivers/pcsp/pcsp.c:54: error: (Each undeclared identifier is reported only once
sound/drivers/pcsp/pcsp.c:54: error: for each function it appears in.)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/pcsp/pcsp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/drivers/pcsp/pcsp.c~git-alsa-tiwai-sound-drivers-pcsp-pcspc-build-fix sound/drivers/pcsp/pcsp.c
--- a/sound/drivers/pcsp/pcsp.c~git-alsa-tiwai-sound-drivers-pcsp-pcspc-build-fix
+++ a/sound/drivers/pcsp/pcsp.c
@@ -12,6 +12,7 @@
 #include <sound/initval.h>
 #include <sound/pcm.h>
 #include <linux/input.h>
+#include <linux/delay.h>
 #include <asm/bitops.h>
 #include "pcsp_input.h"
 #include "pcsp.h"
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

git-alsa-tiwai-sound-drivers-pcsp-pcspc-build-fix.patch
reiser4.patch

