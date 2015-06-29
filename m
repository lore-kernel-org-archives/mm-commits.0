From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:44 -0700
Message-ID: <5591aef0.dgS10Rn4hPFLHWAW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbbF2Urp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.epost@gmail.com, joe@perches.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: alsa-devel@alsa-project.org is moderated for non-subscribers
has been removed from the -mm tree.  Its filename was
     maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jim Davis <jim.epost@gmail.com>
Subject: MAINTAINERS: alsa-devel@alsa-project.org is moderated for non-subscribers

Fix a few inconsistent annotations to show that the alsa-devel mailing
list is moderated for non-subscribers.

Signed-off-by: Jim Davis <jim.epost@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers MAINTAINERS
--- a/MAINTAINERS~maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers
+++ a/MAINTAINERS
@@ -5178,7 +5178,7 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL ASoC BDW/HSW DRIVERS
 M:	Jie Yang <yang.jie@linux.intel.com>
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/intel/sst-haswell*
 F:	sound/soc/intel/sst-dsp*
@@ -6761,7 +6761,7 @@ F:	drivers/net/ethernet/natsemi/natsemi.
 NATIVE INSTRUMENTS USB SOUND INTERFACE DRIVER
 M:	Daniel Mack <zonque@gmail.com>
 S:	Maintained
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.native-instruments.com
 F:	sound/usb/caiaq/
 
@@ -7179,7 +7179,7 @@ F:	arch/arm/mach-omap2/prm*
 OMAP AUDIO SUPPORT
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
 M:	Jarkko Nikula <jarkko.nikula@bitmer.com>
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	sound/soc/omap/
_

Patches currently in -mm which might be from jim.epost@gmail.com are

origin.patch
linux-next.patch

