From: akpm@linux-foundation.org
Subject: + maintainers-remove-arm-clkdev-support-file-pattern.patch added
 to -mm tree
Date: Mon, 29 Jan 2018 15:40:30 -0800
Message-ID: <5a6fb0ee.dF1+qLWsok1eCcT5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeA2Xkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:40:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern
has been added to the -mm tree.  Its filename is
     maintainers-remove-arm-clkdev-support-file-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-arm-clkdev-support-file-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-arm-clkdev-support-file-pattern.patch

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
Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern

34d2f4d3a4d6 ("ARM: Use generic clkdev.h header") removed the file, remove
the pattern.

Link: http://lkml.kernel.org/r/41bfff9449a5894b94f583983b6c6cb46f4cd821.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern
+++ a/MAINTAINERS
@@ -1307,7 +1307,6 @@ M:	Russell King <linux@armlinux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.armlinux.org.uk/~rmk/linux-arm.git clkdev
-F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
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

