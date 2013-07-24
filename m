From: akpm@linux-foundation.org
Subject: + maintainers-update-sirf-patterns.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:16:32 -0700
Message-ID: <51f03620.qJwpTgGW/ogQisux%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3GXUQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, 21cnbao@gmail.com, joe@perches.com

Subject: + maintainers-update-sirf-patterns.patch added to -mm tree
To: joe@perches.com,21cnbao@gmail.com,linus.walleij@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:16:32 -0700


The patch titled
     Subject: MAINTAINERS: update sirf patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-sirf-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-sirf-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-sirf-patterns.patch

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
Subject: MAINTAINERS: update sirf patterns

Commit 3370dc916c ("pinctrl:sirf:re-arch and add support for new
SiRFatlas6 SoC") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-sirf-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sirf-patterns
+++ a/MAINTAINERS
@@ -813,7 +813,7 @@ F:	arch/arm/mach-prima2/
 F:	drivers/dma/sirf-dma.c
 F:	drivers/i2c/busses/i2c-sirf.c
 F:	drivers/mmc/host/sdhci-sirf.c
-F:	drivers/pinctrl/pinctrl-sirf.c
+F:	drivers/pinctrl/sirf/
 F:	drivers/spi/spi-sirf.c
 
 ARM/EBSA110 MACHINE SUPPORT
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-gpio-vt8500-remove-file-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
linux-next.patch

