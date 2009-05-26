From: akpm@linux-foundation.org
Subject: + maintainers-mark-alsa-lists-as-moderated.patch added to -mm tree
Date: Tue, 26 May 2009 14:42:11 -0700
Message-ID: <200905262142.n4QLgBiG029999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbZEZVna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:43:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: mark ALSA lists as moderated
has been added to the -mm tree.  Its filename is
     maintainers-mark-alsa-lists-as-moderated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -487,7 +487,7 @@ AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/aoa/
 
@@ -1432,7 +1432,7 @@ F:	drivers/usb/host/ohci-ep93xx.c
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
@@ -2345,7 +2345,7 @@ F:	drivers/serial/ucc_uart.c
 FREESCALE SOC SOUND DRIVERS
 P:	Timur Tabi
 M:	timur@freescale.com
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	sound/soc/fsl/fsl*
@@ -5321,7 +5321,7 @@ P:	Jaroslav Kysela
 M:	perex@perex.cz
 P:	Takashi Iwai
 M:	tiwai@suse.de
-L:	alsa-devel@alsa-project.org (subscribers-only)
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
 T:	git git://git.alsa-project.org/alsa-kernel.git
@@ -5336,7 +5336,7 @@ M:	lrg@slimlogic.co.uk
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

maintainers-pair-edac-e752x-p-and-m-entries.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch

