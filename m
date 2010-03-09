From: akpm@linux-foundation.org
Subject: [merged] drivers-hwmon-vt8231c-fix-continuation-line-formats.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:24 -0800
Message-ID: <201003091909.o29J9Ovk031523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755818Ab0CITKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, khali@linux-fr.org, vt8231@hiddenengine.co.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/hwmon/vt8231.c: fix continuation line formats
has been removed from the -mm tree.  Its filename was
     drivers-hwmon-vt8231c-fix-continuation-line-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hwmon/vt8231.c: fix continuation line formats
From: Joe Perches <joe@perches.com>

String constants that are continued on subsequent lines with \ will cause
spurious whitespace in the resulting output.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Roger Lucas <vt8231@hiddenengine.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/vt8231.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/hwmon/vt8231.c~drivers-hwmon-vt8231c-fix-continuation-line-formats drivers/hwmon/vt8231.c
--- a/drivers/hwmon/vt8231.c~drivers-hwmon-vt8231c-fix-continuation-line-formats
+++ a/drivers/hwmon/vt8231.c
@@ -948,8 +948,7 @@ static int __devinit vt8231_pci_probe(st
 
 	address = val & ~(VT8231_EXTENT - 1);
 	if (address == 0) {
-		dev_err(&dev->dev, "base address not set -\
-				 upgrade BIOS or use force_addr=0xaddr\n");
+		dev_err(&dev->dev, "base address not set - upgrade BIOS or use force_addr=0xaddr\n");
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from joe@perches.com are

fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
drivers-video-via-fix-continuation-line-formats.patch

