From: akpm@linux-foundation.org
Subject: - mfd-maintainer.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:56 -0700
Message-ID: <200807070304.m6734uEF004709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbYGGDFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, ben-linux@fluff.org, dbaryshkov@gmail.com, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     MFD maintainer
has been removed from the -mm tree.  Its filename was
     mfd-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MFD maintainer
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
@@ -2818,6 +2818,12 @@ W:	https://tango.0pointer.de/mailman/lis
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

linux-next.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
gpiolib-allow-user-selection.patch

