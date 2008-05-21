From: akpm@linux-foundation.org
Subject: + s3c2410-fix-driver-module_alias.patch added to -mm tree
Date: Wed, 21 May 2008 15:14:09 -0700
Message-ID: <200805212214.m4LME90J003462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759532AbYEUWOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:14:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl


The patch titled
     S3C2410: fix driver MODULE_ALIAS()
has been added to the -mm tree.  Its filename is
     s3c2410-fix-driver-module_alias.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: S3C2410: fix driver MODULE_ALIAS()
From: Ben Dooks <ben-fbdev@fluff.org>

Add a correct MODULE_ALIAS() entry for this driver to enable udev module
loading.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/s3c2410fb.c~s3c2410-fix-driver-module_alias drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410-fix-driver-module_alias
+++ a/drivers/video/s3c2410fb.c
@@ -1070,3 +1070,5 @@ MODULE_AUTHOR("Arnaud Patard <arnaud.pat
 	      "Ben Dooks <ben-linux@fluff.org>");
 MODULE_DESCRIPTION("Framebuffer driver for the s3c2410");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:s3c2410-lcd");
+MODULE_ALIAS("platform:s3c2412-lcd");
_

Patches currently in -mm which might be from ben-fbdev@fluff.org are

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch

