From: akpm@linux-foundation.org
Subject: + maintainers-use-t-git-and-whitespace-trivia.patch added to -mm tree
Date: Tue, 28 Sep 2010 15:27:34 -0700
Message-ID: <201009282227.o8SMRY8b021500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab0I1W1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 18:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: use "T: git" and whitespace trivia
has been added to the -mm tree.  Its filename is
     maintainers-use-t-git-and-whitespace-trivia.patch

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
Subject: MAINTAINERS: use "T: git" and whitespace trivia
From: Joe Perches <joe@perches.com>

Add missing git as a prefix for git repositories in the few places it
wasn't already used.

Convert a space delimiter to a tab.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-use-t-git-and-whitespace-trivia MAINTAINERS
--- a/MAINTAINERS~maintainers-use-t-git-and-whitespace-trivia
+++ a/MAINTAINERS
@@ -655,7 +655,7 @@ ARM/FARADAY FA526 PORT
 M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-T:	git://git.berlios.de/gemini-board
+T:	git git://git.berlios.de/gemini-board
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
@@ -670,7 +670,7 @@ ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-T:	git://git.pengutronix.de/git/imx/linux-2.6.git
+T:	git git://git.pengutronix.de/git/imx/linux-2.6.git
 F:	arch/arm/mach-mx*/
 F:	arch/arm/plat-mxc/
 
@@ -3817,7 +3817,7 @@ F:	drivers/net/wireless/mwl8k.c
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-F: drivers/mmc/host/mvsdio.*
+F:	drivers/mmc/host/mvsdio.*
 
 MARVELL YUKON / SYSKONNECT DRIVER
 M:	Mirko Lindner <mlindner@syskonnect.de>
@@ -4894,7 +4894,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4919,7 +4919,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
vsprintfc-use-default-pointer-field-size-for-null-strings.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
lib-fix-scnprintf-if-size-is-==-0.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
scripts-get_maintainerpl-use-correct-indentation.patch
scripts-get_maintainerpl-dont-search-maintainers-for-keywords-or-emails.patch
scripts-get_maintainerpl-add-default-git-fallback-remove-default-git.patch
scripts-get_maintainerpl-use-get_maintainerconf-from-then-home-then-scripts.patch
maintainers-fix-colibri-pxa270-file-pattern.patch
maintainers-merge-imote2-and-stargate.patch
maintainers-merge-s3c-244x-sections.patch
maintainers-merge-s3c6400-and-6410-to-64xx.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch
maintainers-use-t-git-and-whitespace-trivia.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

