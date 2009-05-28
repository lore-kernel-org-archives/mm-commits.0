From: akpm@linux-foundation.org
Subject: + kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch added to -mm tree
Date: Wed, 27 May 2009 23:43:45 -0700
Message-ID: <200905280643.n4S6hjZh014970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbZE1GoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markus.heidelberg@web.de, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     kconfig: fix typo "mconfig" to "menuconfig" in a comment
has been added to the -mm tree.  Its filename is
     kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment.patch

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
Subject: kconfig: fix typo "mconfig" to "menuconfig" in a comment
From: Markus Heidelberg <markus.heidelberg@web.de>

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/Makefile~kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~kconfig-fix-typo-mconfig-to-menuconfig-in-a-comment
+++ a/scripts/kconfig/Makefile
@@ -104,7 +104,7 @@ HOST_EXTRACFLAGS += -DLOCALE
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
-# mconf:  Used for the mconfig target.
+# mconf:  Used for the menuconfig target
 #         Utilizes the lxdialog package
 # qconf:  Used for the xconfig target
 #         Based on QT which needs to be installed to compile it
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

