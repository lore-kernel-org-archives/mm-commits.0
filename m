From: akpm@linux-foundation.org
Subject: + maintainers-remove-android-ion-pattern.patch added to -mm tree
Date: Mon, 29 Jan 2018 15:40:27 -0800
Message-ID: <5a6fb0eb.ZLssJeWIHjQReAKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbeA2Xk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, labbott@redhat.com, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove ANDROID ION pattern
has been added to the -mm tree.  Its filename is
     maintainers-remove-android-ion-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-android-ion-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-android-ion-pattern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-ignore-some-octal-permissions-of-0.patch
checkpatch-improve-quoted-string-and-line-continuation-test.patch
checkpatch-add-a-few-device_attr-style-tests.patch
checkpatch-improve-the-tabstop-test-to-include-declarations.patch
checkpatch-exclude-drivers-staging-from-if-with-unnecessary-parentheses-test.patch
checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch
maintainers-remove-android-ion-pattern.patch
maintainers-remove-arm-clkdev-support-file-pattern.patch
maintainers-update-cortina-gemini-patterns.patch
maintainers-update-arm-oxnas-platform-support-patterns.patch
maintainers-update-various-palm-patterns.patch
maintainers-update-arm-qualcomm-support-patterns.patch

