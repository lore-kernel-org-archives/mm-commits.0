From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-android-ion-pattern.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 12:00:40 -0800
Message-ID: <20180207200040.RCTFn6Drx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGUAl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:00:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, labbott@redhat.com, mm-commits@vger.kernel.org, sumit.semwal@linaro.org


The patch titled
     Subject: MAINTAINERS: remove ANDROID ION pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-android-ion-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove ANDROID ION pattern

File drivers/staging/android/uapi/ion_test.h was removed by 9828282e33a0
("staging: android: ion: Remove old platform support")

Remove the pattern.

Link: http://lkml.kernel.org/r/182debec22002c9a1de44e79a7441288942b205c.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-android-ion-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-android-ion-pattern
+++ a/MAINTAINERS
@@ -903,7 +903,6 @@ L:	devel@driverdev.osuosl.org
 S:	Supported
 F:	drivers/staging/android/ion
 F:	drivers/staging/android/uapi/ion.h
-F:	drivers/staging/android/uapi/ion_test.h
 
 AOA (Apple Onboard Audio) ALSA DRIVER
 M:	Johannes Berg <johannes@sipsolutions.net>
_

Patches currently in -mm which might be from joe@perches.com are


