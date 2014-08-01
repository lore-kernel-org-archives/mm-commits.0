From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-solo6x10-patterns.patch removed from
 -mm tree
Date: Fri, 01 Aug 2014 11:55:20 -0700
Message-ID: <53dbe298.9xEOBBuFc1VyTou2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:39325 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaHASzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Aug 2014 14:55:21 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so829547pab.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Aug 2014 11:55:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hans.verkuil@cisco.com, ismael.luceno@corp.bluecherry.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update solo6x10 patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-solo6x10-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update solo6x10 patterns

commit 28cae868cd24 ("[media] solo6x10: move out of staging into
drivers/media/pci") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN MAINTAINERS~maintainers-update-solo6x10-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-solo6x10-patterns
+++ a/MAINTAINERS
@@ -8420,6 +8420,12 @@ M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
 F:	drivers/leds/leds-net48xx.c
 
+SOFTLOGIC 6x10 MPEG CODEC
+M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
+L:	linux-media@vger.kernel.org
+S:	Supported
+F:	drivers/media/pci/solo6x10/
+
 SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Neil Brown <neilb@suse.de>
 L:	linux-raid@vger.kernel.org
@@ -8683,11 +8689,6 @@ M:	Christopher Harrer <charrer@alacritec
 S:	Odd Fixes
 F:	drivers/staging/slicoss/
 
-STAGING - SOFTLOGIC 6x10 MPEG CODEC
-M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
-S:	Supported
-F:	drivers/staging/media/solo6x10/
-
 STAGING - SPEAKUP CONSOLE SPEECH DRIVER
 M:	William Hubbs <w.d.hubbs@gmail.com>
 M:	Chris Brannon <chris@the-brannons.com>
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
checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch
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
maintainers-update-samsung-pinctrl-patterns.patch
maintainers-update-nomadik-patterns.patch

