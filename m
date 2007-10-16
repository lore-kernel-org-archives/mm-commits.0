From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-pcmcia.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:37 -0700
Message-ID: <200710162029.l9GKTbNd014330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935901AbXJPUaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: PCMCIA
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-pcmcia.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use menuconfig objects: PCMCIA
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/pcmcia/Kconfig~use-menuconfig-objects-pcmcia drivers/pcmcia/Kconfig
--- a/drivers/pcmcia/Kconfig~use-menuconfig-objects-pcmcia
+++ a/drivers/pcmcia/Kconfig
@@ -2,9 +2,7 @@
 # PCCARD (PCMCIA/CardBus) bus subsystem configuration
 #
 
-menu "PCCARD (PCMCIA/CardBus) support"
-
-config PCCARD
+menuconfig PCCARD
 	tristate "PCCard (PCMCIA/CardBus) support"
 	depends on HOTPLUG
 	---help---
@@ -278,5 +276,3 @@ config PCCARD_IODYN
 	bool
 
 endif	# PCCARD
-
-endmenu
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-kvm.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
