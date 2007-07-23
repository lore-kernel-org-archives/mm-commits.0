From: akpm@linux-foundation.org
Subject: + kconfig-remove-top-level-menu-code-maturity-level-options.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:59:22 -0700
Message-ID: <200707232359.l6NNxMmE018761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbXGWX7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:59:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a1426z@gawab.com, sam@ravnborg.org


The patch titled
     Kconfig: remove top level menu "Code maturity level options"
has been added to the -mm tree.  Its filename is
     kconfig-remove-top-level-menu-code-maturity-level-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kconfig: remove top level menu "Code maturity level options"
From: Al Boldi <a1426z@gawab.com>

Remove the top level menu "Code maturity level options", and moves its
options into menu "General setup".

This makes Kconfig less cluttered and easier to setup.

Signed-off-by: Al Boldi <a1426z@gawab.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN init/Kconfig~kconfig-remove-top-level-menu-code-maturity-level-options init/Kconfig
--- a/init/Kconfig~kconfig-remove-top-level-menu-code-maturity-level-options
+++ a/init/Kconfig
@@ -7,7 +7,7 @@ config DEFCONFIG_LIST
 	default "/boot/config-$UNAME_RELEASE"
 	default "arch/$ARCH/defconfig"
 
-menu "Code maturity level options"
+menu "General setup"
 
 config EXPERIMENTAL
 	bool "Prompt for development and/or incomplete code/drivers"
@@ -61,9 +61,6 @@ config INIT_ENV_ARG_LIMIT
 	  Maximum of each of the number of arguments and environment
 	  variables passed to init from the kernel command line.
 
-endmenu
-
-menu "General setup"
 
 config LOCALVERSION
 	string "Local version - append to kernel release"
_

Patches currently in -mm which might be from a1426z@gawab.com are

kconfig-remove-top-level-menu-code-maturity-level-options.patch
