From: akpm@linux-foundation.org
Subject: + maintainers-remove-usb-zc0301-driver.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:09:08 -0700
Message-ID: <201009212209.o8LM98jr004313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587Ab0IUWJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, amwang@redhat.com, mchehab@redhat.com


The patch titled
     MAINTAINERS: remove USB ZC0301 DRIVER
has been added to the -mm tree.  Its filename is
     maintainers-remove-usb-zc0301-driver.patch

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
Subject: MAINTAINERS: remove USB ZC0301 DRIVER
From: Joe Perches <joe@perches.com>

Removed by commit 0d58cef664e01f ("V4L/DVB: Remove obsolete zc0301 v4l
driver").

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Amerigo Wang <amwang@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-usb-zc0301-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-usb-zc0301-driver
+++ a/MAINTAINERS
@@ -6211,16 +6211,6 @@ S:	Supported
 F:	drivers/usb/host/xhci*
 F:	drivers/usb/host/pci-quirks*
 
-USB ZC0301 DRIVER
-M:	Luca Risolia <luca.risolia@studio.unibo.it>
-L:	linux-usb@vger.kernel.org
-L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
-W:	http://www.linux-projects.org
-S:	Maintained
-F:	Documentation/video4linux/zc0301.txt
-F:	drivers/media/video/zc0301/
-
 USB ZD1201 DRIVER
 L:	linux-wireless@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
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

