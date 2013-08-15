From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sirf-patterns.patch removed from -mm
 tree
Date: Thu, 15 Aug 2013 13:20:36 -0700
Message-ID: <520d3814.oXNzslAFAZM4Jvqu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab3HOUUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Aug 2013 16:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, 21cnbao@gmail.com, joe@perches.com

Subject: [merged] maintainers-update-sirf-patterns.patch removed from -mm tree
To: joe@perches.com,21cnbao@gmail.com,linus.walleij@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 Aug 2013 13:20:36 -0700


The patch titled
     Subject: MAINTAINERS: update sirf patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-sirf-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
maintainers-update-ssbi-patterns.patch
maintainers-update-file-pattern-for-arc-uart.patch
maintainers-update-usb-ehci-platform-pattern.patch
maintainers-usb-phy-update-patterns.patch
maintainers-update-gre-demux-patterns.patch
maintainers-append-to-directory-patterns.patch
checkpatch-add-a-few-more-fix-corrections.patch
checkpatch-check-camelcase-by-word-not-by-lval.patch
checkpatch-enforce-sane-perl-version.patch
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
checkpatch-add-types-option-to-report-only-specific-message-types.patch
checkpatch-ignore-define-trace_foo-macros.patch
checkpatch-better-fix-of-spacing-errors.patch
checkpatch-reduce-runtime-cpu-time-used.patch
checkpatch-fix-perl-version-512-and-earlier-incompatibility.patch
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
pktcdvd-fix-defective-misuses-of-pkt_level.patch
linux-next.patch

