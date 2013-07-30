From: akpm@linux-foundation.org
Subject: [merged] maintainers-gpio-vt8500-remove-file-pattern.patch
 removed from -mm tree
Date: Tue, 30 Jul 2013 12:20:16 -0700
Message-ID: <51f811f0.rEw3GE9AZilsUSmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3G3TUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 15:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@prisktech.co.nz, linus.walleij@linaro.org, joe@perches.com

Subject: [merged] maintainers-gpio-vt8500-remove-file-pattern.patch removed from -mm tree
To: joe@perches.com,linus.walleij@linaro.org,linux@prisktech.co.nz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 12:20:16 -0700


The patch titled
     Subject: MAINTAINERS: gpio: vt8500: remove file pattern
has been removed from the -mm tree.  Its filename was
     maintainers-gpio-vt8500-remove-file-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: gpio: vt8500: remove file pattern

Commit dc1010860b ("gpio: vt8500: Remove arch-vt8500 gpio driver") removed
the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-gpio-vt8500-remove-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-gpio-vt8500-remove-file-pattern
+++ a/MAINTAINERS
@@ -1292,7 +1292,6 @@ L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
 F:	arch/arm/mach-vt8500/
 F:	drivers/clocksource/vt8500_timer.c
-F:	drivers/gpio/gpio-vt8500.c
 F:	drivers/i2c/busses/i2c-wmt.c
 F:	drivers/mmc/host/wmt-sdmmc.c
 F:	drivers/pwm/pwm-vt8500.c
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
linux-next.patch
maintainers-exynos-remove-board-files.patch
maintainers-arm-omap2-3-remove-unused-clockdomain-files.patch
maintainers-omap-powerdomain-update-patterns.patch
maintainers-arm-s3c2410-update-patterns.patch
maintainers-arm-spear-consolidate-sections.patch
maintainers-arm-plat-nomadik-update-patterns.patch
maintainers-arm-s3c24xx-remove-plat-s3c24xx.patch
maintainers-ghes_edac-update-pattern.patch
maintainers-update-siano-drivers.patch
maintainers-si4713-fix-file-pattern.patch
maintainers-update-it913x-patterns.patch
maintainers-update-sirf-patterns.patch
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
pktcdvd-convert-zone-macro-to-static-function-get_zone.patch
pktcdvd-convert-printk-to-pr_level.patch
pktcdvd-consolidate-dprintk-and-vprintk-macros.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dbg.patch
pktcdvd-add-struct-pktcdvd_devicename-to-pr_err-logging-where-possible.patch
pktcdvd-convert-pr_notice-to-pkt_notice.patch
pktcdvd-convert-pr_info-to-pkt_info.patch
pktcdvd-add-struct-pktcdvd_device-to-pkt_dump_sense.patch

