From: akpm@linux-foundation.org
Subject: + kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:47 -0700
Message-ID: <200905280643.n4S6hlHI014973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725AbZE1GoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig: add a note about the deps to the 'silentoldconfig' help
has been added to the -mm tree.  Its filename is
     kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch

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

kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch
kconfig-add-a-note-about-the-deps-to-the-silentoldconfig-help.patch
kconfig-resort-the-documentation-of-the-environment-variables.patch
gitignore-ignore-kconfig-i18n-files.patch
kconfig-qconf-fix-wall-compiler-warnings.patch
kconfig-qconf-fix-namespace-for-horizontal-and-vertical-enum-values.patch
kconfig-qconf-add-namespace-for-use-of-key_-enum-values.patch
kconfig-qconf-fix-the-type-of-the-desktop-widget.patch
kconfig-do-not-hardcode-config-filename.patch
kconfig-do-not-hardcode-include-config-autoconf-filename.patch

