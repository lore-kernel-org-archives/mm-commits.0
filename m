From: akpm@linux-foundation.org
Subject: + mmc-add-maintainers-entry.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:07:48 -0700
Message-ID: <201009102307.o8AN7mBc008422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab0IJXH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:07:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, pierre-list@ossman.eu


The patch titled
     mmc: add MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     mmc-add-maintainers-entry.patch

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
Subject: mmc: add MAINTAINERS entry
From: Chris Ball <cjb@laptop.org>

Add myself as maintainer.

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Pierre Ossman <pierre-list@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~mmc-add-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~mmc-add-maintainers-entry
+++ a/MAINTAINERS
@@ -3936,8 +3936,10 @@ S:	Supported
 F:	drivers/mfd/
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
-S:	Orphan
+M:	Chris Ball <cjb@laptop.org>
 L:	linux-mmc@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
+S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
 
@@ -5123,8 +5125,10 @@ S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-S:	Orphan
+M:	Chris Ball <cjb@laptop.org>
 L:	linux-mmc@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
+S:	Maintained
 F:	drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
_

Patches currently in -mm which might be from cjb@laptop.org are

origin.patch
linux-next.patch
mmc-add-maintainers-entry.patch
mmc-mmc-44-ddr-support.patch
mmc-sdhci-make-consistent-use-of-config_mmc_debug-for-debugging.patch
mmc-at91_mcic-use-resource_size.patch
mmc-atmel-mcic-use-resource-size.patch
mmc-au1xmmcc-use-resource_size.patch
mmc-use-snprintf-not-sprintf.patch
drivers-mmc-host-omapc-use-resource_size.patch
drivers-mmc-host-omap_hsmmcc-use-resource_size.patch
mmc-make-id-freq-configurable.patch
mmc-make-id-freq-configurable-v5.patch
mmc_test-collect-data-and-show-it-via-sysfs-by-demand.patch

