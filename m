From: akpm@linux-foundation.org
Subject: [folded] at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:41:24 -0700
Message-ID: <200909222141.n8MLfOgX029048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbZIVVl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nicolas.ferre@atmel.com, rob@emanuele.us, mm-commits@vger.kernel.org


The patch titled
     at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch

This patch was dropped because it was folded into at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#111: FILE: arch/arm/mach-at91/at91sam9260_devices.c:326:
+				at91_set_gpio_input(data->slot[i].detect_pin, 1);

ERROR: space required before the open parenthesis '('
#117: FILE: arch/arm/mach-at91/at91sam9260_devices.c:332:
+			switch(i) {

WARNING: line over 80 characters
#144: FILE: arch/arm/mach-at91/at91sam9260_devices.c:359:
+					"AT91: SD/MMC slot %d not available\n", i);

WARNING: line over 80 characters
#224: FILE: arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c:56:
+	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS

WARNING: line over 80 characters
#229: FILE: arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c:61:
+	at91_register_uart(AT91SAM9260_ID_US1, 2, ATMEL_UART_CTS | ATMEL_UART_RTS);

WARNING: line over 80 characters
#310: FILE: arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c:142:
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)

WARNING: line over 80 characters
#344: FILE: arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c:176:
+	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE,

WARNING: line over 80 characters
#470: FILE: arch/arm/mach-at91/include/mach/board.h:78:
+extern void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data);

total: 1 errors, 7 warnings, 422 lines checked

./patches/at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Rob Emanuele <rob@emanuele.us>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-at91/at91sam9260_devices.c~at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes arch/arm/mach-at91/at91sam9260_devices.c
--- a/arch/arm/mach-at91/at91sam9260_devices.c~at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes
+++ a/arch/arm/mach-at91/at91sam9260_devices.c
@@ -329,7 +329,7 @@ void __init at91_add_device_mci(short mm
 			if (data->slot[i].wp_pin)
 				at91_set_gpio_input(data->slot[i].wp_pin, 1);
 
-			switch(i) {
+			switch (i) {
 			case 0:
 				/* CMD */
 				at91_set_A_periph(AT91_PIN_PA7, 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
mmc-core-sdio-suspend-resume-support-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
walk-system-ram-range-fix-2.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch

