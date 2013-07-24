From: akpm@linux-foundation.org
Subject: + maintainers-update-file-pattern-for-arc-uart.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:16:34 -0700
Message-ID: <51f03622.JWXCoKlJ8tS9KX6j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3GXUQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:16:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + maintainers-update-file-pattern-for-arc-uart.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:16:34 -0700


The patch titled
     Subject: MAINTAINERS: update file pattern for ARC uart
has been added to the -mm tree.  Its filename is
     maintainers-update-file-pattern-for-arc-uart.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-file-pattern-for-arc-uart.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-file-pattern-for-arc-uart.patch

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
Subject: MAINTAINERS: update file pattern for ARC uart

Commit 6659a20a76 ("ARC: MAINTAINERS update for ARC") typoed the file
pattern.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-file-pattern-for-arc-uart MAINTAINERS
--- a/MAINTAINERS~maintainers-update-file-pattern-for-arc-uart
+++ a/MAINTAINERS
@@ -7968,7 +7968,7 @@ M:	Vineet Gupta <vgupta@synopsys.com>
 S:	Supported
 F:	arch/arc/
 F:	Documentation/devicetree/bindings/arc/
-F:	drivers/tty/serial/arc-uart.c
+F:	drivers/tty/serial/arc_uart.c
 
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
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

