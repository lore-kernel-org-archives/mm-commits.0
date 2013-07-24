From: akpm@linux-foundation.org
Subject: + maintainers-omap-powerdomain-update-patterns.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:16:22 -0700
Message-ID: <51f03616.GUWoah7MgQR9UK1f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GXUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com, rnayak@ti.com, paul@pwsan.com, cesarb@cesarb.eti.br, joe@perches.com

Subject: + maintainers-omap-powerdomain-update-patterns.patch added to -mm tree
To: joe@perches.com,cesarb@cesarb.eti.br,paul@pwsan.com,rnayak@ti.com,santosh.shilimkar@ti.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:16:22 -0700


The patch titled
     Subject: MAINTAINERS: OMAP POWERDOMAIN, update patterns
has been added to the -mm tree.  Its filename is
     maintainers-omap-powerdomain-update-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-omap-powerdomain-update-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-omap-powerdomain-update-patterns.patch

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
Subject: MAINTAINERS: OMAP POWERDOMAIN, update patterns

Commit 498153995b9 ("ARM: OMAP2+: powerdomain/PRM: move the low-level
powerdomain") renamed the files, update the patterns.

Identical to a patch earlier sent by Cesar Eduardo Barros.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-omap-powerdomain-update-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-omap-powerdomain-update-patterns
+++ a/MAINTAINERS
@@ -5898,13 +5898,12 @@ S:	Maintained
 F:	arch/arm/*omap*/*pm*
 F:	drivers/cpufreq/omap-cpufreq.c
 
-OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
+OMAP POWERDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
-F:	arch/arm/mach-omap2/powerdomain44xx.c
+F:	arch/arm/mach-omap2/prm*
 
 OMAP AUDIO SUPPORT
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
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

