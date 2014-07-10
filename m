From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-staging-removals-and-movements.patch
 removed from -mm tree
Date: Thu, 10 Jul 2014 12:22:47 -0700
Message-ID: <53bee807.LPEztcCwFHNkHZ9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39098 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaGJTWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 15:22:48 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so17741igi.5
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 12:22:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update staging removals and movements
has been removed from the -mm tree.  Its filename was
     maintainers-update-staging-removals-and-movements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update staging removals and movements

3 sections have been deleted by various commits.  The other, echo, has
been moved to drivers/misc.

The nominal maintainers of the echo subsystem haven't been modifying the
code or acking/signing patches for several years, so don't keep the
section either.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN MAINTAINERS~maintainers-update-staging-removals-and-movements MAINTAINERS
--- a/MAINTAINERS~maintainers-update-staging-removals-and-movements
+++ a/MAINTAINERS
@@ -5058,13 +5058,6 @@ S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
-KTAP
-M:	Jovi Zhangwei <jovi.zhangwei@gmail.com>
-W:	http://www.ktap.org
-L:	ktap@freelists.org
-S:	Maintained
-F:	drivers/staging/ktap/
-
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
@@ -8523,23 +8516,12 @@ L:	devel@driverdev.osuosl.org
 S:	Supported
 F:	drivers/staging/
 
-STAGING - ASUS OLED
-M:	Jakub Schmidtke <sjakub@gmail.com>
-S:	Odd Fixes
-F:	drivers/staging/asus_oled/
-
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
 S:	Odd Fixes
 F:	drivers/staging/comedi/
 
-STAGING - ECHO CANCELLER
-M:	Steve Underwood <steveu@coppice.org>
-M:	David Rowe <david@rowetel.com>
-S:	Odd Fixes
-F:	drivers/staging/echo/
-
 STAGING - ET131X NETWORK DRIVER
 M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
@@ -8611,11 +8593,6 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/rtl8723au/
 
-STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
-M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
-S:	Odd Fixes
-F:	drivers/staging/sm7xxfb/
-
 STAGING - SLICOSS
 M:	Lior Dotan <liodot@gmail.com>
 M:	Christopher Harrer <charrer@alacritech.com>
_

Patches currently in -mm which might be from joe@perches.com are

fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
maintainers-remove-two-ancient-eata-sections.patch
kernelh-remove-deprecated-pack_hex_byte.patch
mm-utilc-add-kstrimdup.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
checkpatch-emit-a-warning-on-file-add-move-delete.patch
checkpatch-warn-on-break-after-goto-or-return-with-same-tab-indentation.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
fs-isofs-logging-clean-up.patch
proc-constify-seq_operations.patch
sysctl-remove-now-unused-typedef-ctl_table.patch
sysctl-remove-now-unused-typedef-ctl_table-fix.patch
adfs-add-__printf-verification-fix-format-argument-mismatches.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
linux-next.patch
pci-dma-compat-add-pci_zalloc_consistent-helper.patch
atm-use-pci_zalloc_consistent.patch
block-use-pci_zalloc_consistent.patch
crypto-use-pci_zalloc_consistent.patch
infiniband-use-pci_zalloc_consistent.patch
i810-use-pci_zalloc_consistent.patch
media-use-pci_zalloc_consistent.patch
amd-use-pci_zalloc_consistent.patch
atl1e-use-pci_zalloc_consistent.patch
enic-use-pci_zalloc_consistent.patch
sky2-use-pci_zalloc_consistent.patch
micrel-use-pci_zalloc_consistent.patch
qlogic-use-pci_zalloc_consistent.patch
irda-use-pci_zalloc_consistent.patch
ipw2100-use-pci_zalloc_consistent.patch
mwl8k-use-pci_zalloc_consistent.patch
rtl818x-use-pci_zalloc_consistent.patch
rtlwifi-use-pci_zalloc_consistent.patch
scsi-use-pci_zalloc_consistent.patch
staging-use-pci_zalloc_consistent.patch
synclink_gt-use-pci_zalloc_consistent.patch
vme-bridges-use-pci_zalloc_consistent.patch
amd-neaten-and-remove-unnecessary-oom-messages.patch
maintainers-update-microcode-patterns.patch
maintainers-update-cifs-location.patch
maintainers-use-the-correct-efi-stub-location.patch
maintainers-update-clk-sirf-patterns.patch
maintainers-fix-ssbi-pattern.patch
maintainers-use-correct-filename-for-sdhci-bcm-kona.patch
maintainers-fix-pxa3xx-nand-flash-driver-pattern.patch
maintainers-update-picoxcell-patterns.patch
maintainers-remove-section-cirrus-logic-ep93xx-ohci-usb-host-driver.patch
maintainers-remove-metag-imgdafs-pattern.patch
maintainers-remove-unused-radeon-drm-pattern.patch
maintainers-remove-unusd-arm-qualcomm-msm-pattern.patch
maintainers-remove-unused-nfsd-pattern.patch

