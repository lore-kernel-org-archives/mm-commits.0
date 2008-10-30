From: akpm@linux-foundation.org
Subject: + acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch added to -mm tree
Date: Thu, 30 Oct 2008 15:29:57 -0700
Message-ID: <200810302229.m9UMTvS7009782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbYJ3WaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 18:30:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, lenb@kernel.org


The patch titled
     acpi: fix ACPI_FADT_S4_RTC_WAKE comment
has been added to the -mm tree.  Its filename is
     acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
rtc-ds1307-remove-legacy-probe-checks.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch

