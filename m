From: akpm@linux-foundation.org
Subject: + backlight-add-lm3533-backlight-driver-v4.patch added to -mm tree
Date: Tue, 15 May 2012 12:19:16 -0700
Message-ID: <20120515191916.8AF86A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57520 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab2EOTTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 15:19:18 -0400
Received: by bkty5 with SMTP id y5so332210bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 12:19:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com


The patch titled
     Subject: backlight-add-lm3533-backlight-driver-v4
has been added to the -mm tree.  Its filename is
     backlight-add-lm3533-backlight-driver-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight-add-lm3533-backlight-driver-v4

 - fix sysfs-ABI-documentation typo

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-v4 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-v4
+++ a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
@@ -3,7 +3,7 @@ Date:		April 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0,..2), where
+		Set the ALS-control mode (0..2), where
 
 		0 - disabled
 		1 - ALS-mapper 1 (backlight 0)
_
Subject: Subject: backlight-add-lm3533-backlight-driver-v4

Patches currently in -mm which might be from jhovold@gmail.com are

linux-next.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-add-lm3533-backlight-driver-v4.patch

