From: akpm@linux-foundation.org
Subject: + maintainers-arm-spear-consolidate-sections.patch added to -mm
 tree
Date: Wed, 24 Jul 2013 13:16:24 -0700
Message-ID: <51f03618.eCvVJfQBopWKoF+I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3GXUQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:16:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viresh.kumar@linaro.org, arnd@arndb.de, joe@perches.com

Subject: + maintainers-arm-spear-consolidate-sections.patch added to -mm tree
To: joe@perches.com,arnd@arndb.de,viresh.kumar@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:16:24 -0700


The patch titled
     Subject: MAINTAINERS: ARM: spear: consolidate sections
has been added to the -mm tree.  Its filename is
     maintainers-arm-spear-consolidate-sections.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-arm-spear-consolidate-sections.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-arm-spear-consolidate-sections.patch

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
Subject: MAINTAINERS: ARM: spear: consolidate sections

Commit a7ed099ffc8 ("ARM: spear: move all files to mach-spear") moved all
the files into a single directory, delete the now unnecessary duplicate
sections and update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff -puN MAINTAINERS~maintainers-arm-spear-consolidate-sections MAINTAINERS
--- a/MAINTAINERS~maintainers-arm-spear-consolidate-sections
+++ a/MAINTAINERS
@@ -7708,35 +7708,7 @@ L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
-F:	arch/arm/plat-spear/
-
-SPEAR13XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear13xx/
-
-SPEAR3XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear3xx/
-
-SPEAR6XX MACHINE SUPPORT
-M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:	Viresh Kumar <viresh.linux@gmail.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear6xx/
+F:	arch/arm/mach-spear/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
 M:	Viresh Kumar <viresh.linux@gmail.com>
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

