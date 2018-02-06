From: akpm@linux-foundation.org
Subject: [patch 108/114] MAINTAINERS: remove ANDROID ION pattern
Date: Tue, 06 Feb 2018 15:42:23 -0800
Message-ID: <20180206234223.eajB4wIgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754145AbeBFXmY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, labbott@redhat.com, mm-commits@vger.kernel.org, sumit.semwal@linaro.org, torvalds@linux-foundation.org

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
