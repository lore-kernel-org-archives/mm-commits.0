From: akpm@linux-foundation.org
Subject: [merged] acpica-fix-acpi_ex_release_mutex-comment.patch removed from -mm tree
Date: Fri, 12 Mar 2010 12:27:40 -0800
Message-ID: <201003122027.o2CKReYN006220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934556Ab0CLU1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 15:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bzolnier@gmail.com, error27@gmail.com, lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpica: fix acpi_ex_release_mutex() comment
has been removed from the -mm tree.  Its filename was
     acpica-fix-acpi_ex_release_mutex-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpica: fix acpi_ex_release_mutex() comment
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

trivial, leftover from my NULL pointer dereference patch which got
'superseded' by commit fbc3be2

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpica/exmutex.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/acpi/acpica/exmutex.c~acpica-fix-acpi_ex_release_mutex-comment drivers/acpi/acpica/exmutex.c
--- a/drivers/acpi/acpica/exmutex.c~acpica-fix-acpi_ex_release_mutex-comment
+++ a/drivers/acpi/acpica/exmutex.c
@@ -234,8 +234,7 @@ acpi_ex_acquire_mutex(union acpi_operand
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	/* Must have a valid thread ID */
-
+	/* Must have a valid thread. */
 	if (!walk_state->thread) {
 		ACPI_ERROR((AE_INFO,
 			    "Cannot acquire Mutex [%4.4s], null thread info",
_

Patches currently in -mm which might be from bzolnier@gmail.com are

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
documentation-remove-obsolete-voyagertxt-file.patch
linux-next.patch
acpica-fix-acpi_ex_release_mutex-comment.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch

