From: akpm@linux-foundation.org
Subject: + s3c-rtc-remove-unused-variable.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:52:16 -0700
Message-ID: <200710292052.l9TKqGML022736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbXJ2UxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, ben-linux@fluff.org


The patch titled
     s3c-rtc: remove unused variable
has been added to the -mm tree.  Its filename is
     s3c-rtc-remove-unused-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c-rtc: remove unused variable
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~s3c-rtc-remove-unused-variable drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~s3c-rtc-remove-unused-variable
+++ a/drivers/rtc/rtc-s3c.c
@@ -542,8 +542,6 @@ static int s3c_rtc_probe(struct platform
 
 /* RTC Power management control */
 
-static struct timespec s3c_rtc_delta;
-
 static int ticnt_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
s3c-rtc-remove-unused-variable.patch
