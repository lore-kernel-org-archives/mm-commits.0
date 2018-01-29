From: akpm@linux-foundation.org
Subject: + maintainers-update-arm-oxnas-platform-support-patterns.patch
 added to -mm tree
Date: Mon, 29 Jan 2018 15:40:35 -0800
Message-ID: <5a6fb0f3.Or668JsphDsFtDO/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, arnd@arndb.de, daniel@makrotopia.org, narmstrong@baylibre.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update "ARM/OXNAS platform support" patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-arm-oxnas-platform-support-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-arm-oxnas-platform-support-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-arm-oxnas-platform-support-patterns.patch

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
Subject: MAINTAINERS: update "ARM/OXNAS platform support" patterns

9e6c62b05c1b ("ARM: dts: rename oxnas dts files") renamed the files,
update the patterns.

Link: http://lkml.kernel.org/r/b39d779e143b3c0a4e7dff827346e509447e3e8e.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-arm-oxnas-platform-support-patterns
+++ a/MAINTAINERS
@@ -1736,8 +1736,8 @@ L:	linux-oxnas@lists.tuxfamily.org (mode
 S:	Maintained
 F:	arch/arm/mach-oxnas/
 F:	arch/arm/boot/dts/ox8*.dtsi
-F:	arch/arm/boot/dts/wd-mbwe.dts
-F:	arch/arm/boot/dts/cloudengines-pogoplug-series-3.dts
+F:	arch/arm/boot/dts/ox810se-wd-mbwe.dts
+F:	arch/arm/boot/dts/ox820-cloudengines-pogoplug-series-3.dts
 N:	oxnas
 
 ARM/PALM TREO SUPPORT
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

