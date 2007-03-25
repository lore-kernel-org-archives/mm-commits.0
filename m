From: akpm@linux-foundation.org
Subject: + apm-remove-the-apm_rtc_is_gmt-config-option.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:31:50 -0800
Message-ID: <200703252231.l2PMVomP004272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbXCYWbw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com


The patch titled
     apm: remove the APM_RTC_IS_GMT config option.
has been added to the -mm tree.  Its filename is
     apm-remove-the-apm_rtc_is_gmt-config-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: apm: remove the APM_RTC_IS_GMT config option.
From: "Parag Warudkar" <parag.warudkar@gmail.com>

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN arch/i386/Kconfig~apm-remove-the-apm_rtc_is_gmt-config-option arch/i386/Kconfig
--- a/arch/i386/Kconfig~apm-remove-the-apm_rtc_is_gmt-config-option
+++ a/arch/i386/Kconfig
@@ -1050,19 +1050,6 @@ config APM_DISPLAY_BLANK
 	  backlight at all, or it might print a lot of errors to the console,
 	  especially if you are using gpm.
 
-config APM_RTC_IS_GMT
-	bool "RTC stores time in GMT"
-	depends on APM
-	help
-	  Say Y here if your RTC (Real Time Clock a.k.a. hardware clock)
-	  stores the time in GMT (Greenwich Mean Time). Say N if your RTC
-	  stores localtime.
-
-	  It is in fact recommended to store GMT in your RTC, because then you
-	  don't have to worry about daylight savings time changes. The only
-	  reason not to use GMT in your RTC is if you also run a broken OS
-	  that doesn't understand GMT.
-
 config APM_ALLOW_INTS
 	bool "Allow interrupts during APM BIOS calls"
 	depends on APM
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

make-aout-executables-work-again.patch
make-aout-executables-work-again-fix.patch
apmc-get-rid-of-unused-variables.patch
apm-remove-the-apm_rtc_is_gmt-config-option.patch
keyboardc-stop-flooding-dmesg-with-useless-warnings.patch
