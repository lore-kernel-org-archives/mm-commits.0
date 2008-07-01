From: akpm@linux-foundation.org
Subject: + mfd-maintainer.patch added to -mm tree
Date: Tue, 01 Jul 2008 01:41:08 -0700
Message-ID: <200807010841.m618f8NZ017981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYGAImg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 04:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com, ben-linux@fluff.org, dbaryshkov@gmail.com, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, spyro@f2s.com


The patch titled
     ] MFD maintainer
has been added to the -mm tree.  Its filename is
     mfd-maintainer.patch

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
Subject: ] MFD maintainer
From: Samuel Ortiz <sameo@openedhand.com>

We probably need someone to look after the few drivers/mfd patches coming
every now and then.  As agreed with Andrew, I'm ok to do so and my
employer is fine with me spending a few working hours on it, if needed. 
Ben, Philipp, feel free to add your names there too if you wish.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Cc: "pHilipp Zabel" <philipp.zabel@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~mfd-maintainer MAINTAINERS
--- a/MAINTAINERS~mfd-maintainer
+++ a/MAINTAINERS
@@ -2850,6 +2850,12 @@ W:	https://tango.0pointer.de/mailman/lis
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
+MULTIFUNCTION DEVICES (MFD)
+P:	Samuel Ortiz
+M:	sameo@openedhand.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-platform_get_irq-may-return-signed-unnoticed.patch
asic3-gpiolib-support.patch
asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation.patch
asic3-use-dev_-macros.patch
asic3-use-uppercase-only-for-macros-and-defines.patch
mfd-move-asic3-probe-functions-into-__init-section.patch
mfd-maintainer.patch

