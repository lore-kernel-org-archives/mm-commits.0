From: akpm@linux-foundation.org
Subject: +
 maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch added to -mm tree
Date: Mon, 08 Jun 2015 14:12:44 -0700
Message-ID: <5576054c.mU6rEg5kK8rZugZy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbFHVMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2015 17:12:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.epost@gmail.com, joe@perches.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: alsa-devel@alsa-project.org is moderated for non-subscribers
has been added to the -mm tree.  Its filename is
     maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5102,7 +5102,7 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL ASoC BDW/HSW DRIVERS
 M:	Jie Yang <yang.jie@linux.intel.com>
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/intel/sst-haswell*
 F:	sound/soc/intel/sst-dsp*
@@ -6679,7 +6679,7 @@ F:	drivers/net/ethernet/natsemi/natsemi.
 NATIVE INSTRUMENTS USB SOUND INTERFACE DRIVER
 M:	Daniel Mack <zonque@gmail.com>
 S:	Maintained
-L:	alsa-devel@alsa-project.org
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.native-instruments.com
 F:	sound/usb/caiaq/
 
@@ -7097,7 +7097,7 @@ F:	arch/arm/mach-omap2/prm*
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

memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
linux-next.patch

