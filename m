From: akpm@linux-foundation.org
Subject: + maintainers-update-usb-gadget-patterns.patch added to -mm tree
Date: Wed, 30 Jul 2014 14:07:03 -0700
Message-ID: <53d95e77.SEqDyqOwCk9Vpizq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:34146 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaG3VHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:07:05 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so545326oac.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:07:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andrzej.p@samsung.com, dahlmann.thomas@arcor.de, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, laurent.pinchart@ideasonboard.com, leoli@freescale.com, linux@arm.linux.org.uk, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update usb/gadget patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-usb-gadget-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-usb-gadget-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-usb-gadget-patterns.patch

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
Subject: MAINTAINERS: update usb/gadget patterns

Several commits have moved files around, update the section patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN MAINTAINERS~maintainers-update-usb-gadget-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-usb-gadget-patterns
+++ a/MAINTAINERS
@@ -597,7 +597,7 @@ AMD GEODE CS5536 USB DEVICE CONTROLLER D
 M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/amd5536udc.*
+F:	drivers/usb/gadget/udc/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Andres Salomon <dilinger@queued.net>
@@ -1698,7 +1698,7 @@ ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
-F:	drivers/usb/gadget/atmel_usba_udc.*
+F:	drivers/usb/gadget/udc/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
 M:	Simon Kelley <simon@thekelleys.org.uk>
@@ -3815,7 +3815,7 @@ M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
-F:	drivers/usb/gadget/fsl*
+F:	drivers/usb/gadget/udc/fsl*
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 M:	Li Yang <leoli@freescale.com>
@@ -7249,7 +7249,7 @@ S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
 F:	drivers/spi/spi-pxa2xx*
-F:	drivers/usb/gadget/pxa2*
+F:	drivers/usb/gadget/udc/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
 F:	sound/soc/pxa/
@@ -9600,8 +9600,8 @@ USB WEBCAM GADGET
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
-F:	drivers/usb/gadget/*uvc*.c
-F:	drivers/usb/gadget/webcam.c
+F:	drivers/usb/gadget/function/*uvc*.c
+F:	drivers/usb/gadget/legacy/webcam.c
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 M:	Jussi Kivilinna <jussi.kivilinna@iki.fi>
_

Patches currently in -mm which might be from joe@perches.com are

fs-fscache-make-ctl_table-static.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
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
checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
checkpatch-use-the-correct-indentation-for-which.patch
checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch
checkpatch-fix-brace-style-misuses-of-else-and-while.patch
checkpatch-add-for_each-tests-to-indentation-and-brace-tests.patch
checkpatch-add-short-int-to-c-variable-types.patch
checkpatch-add-signed-generic-types.patch
checkpatch-add-test-for-native-c90-types-in-unusual-order.patch
checkpatch-fix-false-positive-missing_break-warnings-with-file.patch
checkpatch-fix-false-positives-for-strict-space-after-cast-test.patch
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
maintainers-remove-two-ancient-eata-sections.patch
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
fsh-remove-unnecessary-extern-prototypes.patch
fsh-whitespace-neatening.patch
fsh-a-few-more-whitespace-neatenings.patch
fsh-add-argument-names-to-struct-file_lock_operations-funcs.patch
fsh-add-member-argument-descriptions-to-lock_manager_operations.patch
dlm-plock-add-argument-descriptions-to-notify.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch
maintainers-update-dma-buffer-sharing-patterns.patch
maintainers-update-usb-gadget-patterns.patch
maintainers-update-go7007-pattern.patch
maintainers-update-solo6x10-patterns.patch
maintainers-update-samsung-pinctrl-patterns.patch
maintainers-update-nomadik-patterns.patch

