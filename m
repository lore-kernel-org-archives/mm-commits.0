From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-move-to-separate-directory-for-easier-modification-fix.patch removed from -mm tree
Date: Wed, 31 Jul 2013 13:48:16 -0700
Message-ID: <51f97810.88Kaj4BNRzxK3SgS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655Ab3GaUsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jul 2013 16:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, joe@perches.com

Subject: [folded-merged] printk-move-to-separate-directory-for-easier-modification-fix.patch removed from -mm tree
To: joe@perches.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 31 Jul 2013 13:48:16 -0700


The patch titled
     Subject: docproc: Move printk file location
has been removed from the -mm tree.  Its filename was
     printk-move-to-separate-directory-for-easier-modification-fix.patch

This patch was dropped because it was folded into printk-move-to-separate-directory-for-easier-modification.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: docproc: Move printk file location

> docproc: kernel/printk.c: No such file or directory

So rename the file.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/device-drivers.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/device-drivers.tmpl~printk-move-to-separate-directory-for-easier-modification-fix Documentation/DocBook/device-drivers.tmpl
--- a/Documentation/DocBook/device-drivers.tmpl~printk-move-to-separate-directory-for-easier-modification-fix
+++ a/Documentation/DocBook/device-drivers.tmpl
@@ -84,7 +84,7 @@ X!Iinclude/linux/kobject.h
 
      <sect1><title>Kernel utility functions</title>
 !Iinclude/linux/kernel.h
-!Ekernel/printk.c
+!Ekernel/printk/printk.c
 !Ekernel/panic.c
 !Ekernel/sys.c
 !Ekernel/rcupdate.c
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
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
checkpatch-check-for-duplicate-signatures.patch
checkpatch-warn-when-using-extern-with-function-prototypes-in-h-files.patch
checkpatch-fix-networking-kernel-doc-block-comment-defect.patch
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
linux-next.patch

