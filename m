From: akpm@linux-foundation.org
Subject: + maintainers-fix-colibri-pxa270-file-pattern.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:08:58 -0700
Message-ID: <201009212208.o8LM8wWB004297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab0IUWJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, marek.vasut@gmail.com


The patch titled
     MAINTAINERS: fix Colibri PXA270 file pattern
has been added to the -mm tree.  Its filename is
     maintainers-fix-colibri-pxa270-file-pattern.patch

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
Subject: MAINTAINERS: fix Colibri PXA270 file pattern
From: Joe Perches <joe@perches.com>

The original commit 403d29713e0a ("pxa/income: Add Income SBC support")
started with the wrong file pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-colibri-pxa270-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-colibri-pxa270-file-pattern
+++ a/MAINTAINERS
@@ -708,8 +708,7 @@ ARM/INCOME PXA270 SUPPORT
 M:	Marek Vasut <marek.vasut@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-F:	arch/arm/mach-pxa/income.c
-F:	arch/arm/mach-pxa/include/mach-pxa/income.h
+F:	arch/arm/mach-pxa/colibri-pxa270-income.c
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
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

