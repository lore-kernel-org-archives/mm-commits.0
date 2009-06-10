From: akpm@linux-foundation.org
Subject: [merged] kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:45:24 -0700
Message-ID: <200906101745.n5AHjOSc031972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbZFJRsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     kconfig: add a note about the deps to the 'silentoldconfig' help
has been removed from the -mm tree.  Its filename was
     kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kconfig: add a note about the deps to the 'silentoldconfig' help
From: Markus Heidelberg <markus.heidelberg@web.de>

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 README                   |    1 +
 scripts/kconfig/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN README~kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help README
--- a/README~kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help
+++ a/README
@@ -174,6 +174,7 @@ CONFIGURING the kernel:
 	"make silentoldconfig"
 			   Like above, but avoids cluttering the screen
 			   with questions already answered.
+			   Additionally updates the dependencies.
 	"make defconfig"   Create a ./.config file by using the default
 			   symbol values from arch/$ARCH/defconfig.
 	"make allyesconfig"
diff -puN scripts/kconfig/Makefile~kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help
+++ a/scripts/kconfig/Makefile
@@ -83,7 +83,7 @@ help:
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
 	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
-	@echo  '  silentoldconfig - Same as oldconfig, but quietly'
+	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
_

Patches currently in -mm which might be from markus.heidelberg@web.de are

linux-next.patch

