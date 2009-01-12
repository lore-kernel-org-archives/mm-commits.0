From: akpm@linux-foundation.org
Subject: - acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:14 -0800
Message-ID: <200901121958.n0CJwEYm027440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607AbZALUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: fix ACPI_FADT_S4_RTC_WAKE comment
has been removed from the -mm tree.  Its filename was
     acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix ACPI_FADT_S4_RTC_WAKE comment
From: David Brownell <dbrownell@users.sourceforge.net>

Make the comment for ACPI_FADT_S4_RTC_WAKE match the ACPI spec;
that bit has nothing to do with status bits.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/actbl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/acpi/actbl.h~acpi-fix-acpi_fadt_s4_rtc_wake-comment include/acpi/actbl.h
--- a/include/acpi/actbl.h~acpi-fix-acpi_fadt_s4_rtc_wake-comment
+++ a/include/acpi/actbl.h
@@ -245,7 +245,7 @@ struct acpi_table_fadt {
 #define ACPI_FADT_POWER_BUTTON      (1<<4)	/* 04: Power button is handled as a generic feature */
 #define ACPI_FADT_SLEEP_BUTTON      (1<<5)	/* 05: Sleep button is handled as a generic feature, or  not present */
 #define ACPI_FADT_FIXED_RTC         (1<<6)	/* 06: RTC wakeup stat not in fixed register space */
-#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup stat not possible from S4 */
+#define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: RTC wakeup possible from S4 */
 #define ACPI_FADT_32BIT_TIMER       (1<<8)	/* 08: tmr_val is 32 bits 0=24-bits */
 #define ACPI_FADT_DOCKING_SUPPORTED (1<<9)	/* 09: Docking supported */
 #define ACPI_FADT_RESET_REGISTER    (1<<10)	/* 10: System reset via the FADT RESET_REG supported */
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller-update.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

