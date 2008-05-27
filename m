From: akpm@linux-foundation.org
Subject: - s3c2410-fix-driver-module_alias.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:04 -0700
Message-ID: <200805270728.m4R7S4w0014886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756595AbYE0Hgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     S3C2410: fix driver MODULE_ALIAS()
has been removed from the -mm tree.  Its filename was
     s3c2410-fix-driver-module_alias.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


