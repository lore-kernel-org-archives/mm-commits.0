From: akpm@linux-foundation.org
Subject: [merged] maintainers-mark-alsa-lists-as-moderated.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:31 -0700
Message-ID: <200906171838.n5HIcV5w004609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758434AbZFQSqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: mark ALSA lists as moderated
has been removed from the -mm tree.  Its filename was
     maintainers-mark-alsa-lists-as-moderated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: mark ALSA lists as moderated
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-mark-alsa-lists-as-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-mark-alsa-lists-as-moderated
+++ a/MAINTAINERS
@@ -489,7 +489,7 @@ AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/aoa/
 
@@ -1437,7 +1437,7 @@ F:	drivers/usb/host/ohci-ep93xx.c
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
@@ -2366,7 +2366,7 @@ F:	drivers/serial/ucc_uart.c
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	sound/soc/fsl/fsl*
@@ -5426,7 +5426,7 @@ P:	Jaroslav Kysela
 M:	perex@perex.cz
 P:	Takashi Iwai
 M:	tiwai@suse.de
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
 T:	git git://git.alsa-project.org/alsa-kernel.git
@@ -5441,7 +5441,7 @@ M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 F:	sound/soc/
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

