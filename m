From: akpm@linux-foundation.org
Subject: - mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:44 -0700
Message-ID: <200810182320.m9INKiFl029813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYJRXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd/ucb1400 sound driver uses/depends on AC97_BUS
has been removed from the -mm tree.  Its filename was
     mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd/ucb1400 sound driver uses/depends on AC97_BUS
From: Randy Dunlap <randy.dunlap@oracle.com>

mfd/ucb1400 sound driver uses/depends on AC97_BUS:

ERROR: "ac97_bus_type" [drivers/mfd/ucb1400_core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus
+++ a/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_PASIC3
 
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
+	depends on AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

