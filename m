From: akpm@linux-foundation.org
Subject: - s3c-rtc-remove-unused-variable.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:38 -0700
Message-ID: <200710301806.l9UI6cDG020540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbXJ3SSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     s3c-rtc: remove unused variable
has been removed from the -mm tree.  Its filename was
     s3c-rtc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-alsa.patch
