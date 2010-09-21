From: akpm@linux-foundation.org
Subject: + maintainers-merge-imote2-and-stargate.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:09:00 -0700
Message-ID: <201009212209.o8LM90jt004300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab0IUWJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, eric.y.miao@gmail.com, jic23@cam.ac.uk


The patch titled
     MAINTAINERS: merge imote2 and stargate
has been added to the -mm tree.  Its filename is
     maintainers-merge-imote2-and-stargate.patch

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
Subject: MAINTAINERS: merge imote2 and stargate
From: Joe Perches <joe@perches.com>

Removed by commit dcd925f95194da4 ("pxa: merge stargate2 and imote2 board
files"). 

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN MAINTAINERS~maintainers-merge-imote2-and-stargate MAINTAINERS
--- a/MAINTAINERS~maintainers-merge-imote2-and-stargate
+++ a/MAINTAINERS
@@ -755,13 +755,7 @@ L:	linux-arm-kernel@lists.infradead.org 
 S:	Maintained
 F:	arch/arm/mach-ixp4xx/
 
-ARM/INTEL RESEARCH IMOTE 2 MACHINE SUPPORT
-M:	Jonathan Cameron <jic23@cam.ac.uk>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/mach-pxa/imote2.c
-
-ARM/INTEL RESEARCH STARGATE 2 MACHINE SUPPORT
+ARM/INTEL RESEARCH IMOTE/STARGATE 2 MACHINE SUPPORT
 M:	Jonathan Cameron <jic23@cam.ac.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-add-irq-subsystem.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
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
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

