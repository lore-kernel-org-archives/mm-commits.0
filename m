From: akpm@linux-foundation.org
Subject: - apm-remove-the-apm_rtc_is_gmt-config-option.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:21 -0700
Message-ID: <200703292339.l2TNdLOe015425@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945944AbXC2XjX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     apm: remove the APM_RTC_IS_GMT config option.
has been removed from the -mm tree.  Its filename was
     apm-remove-the-apm_rtc_is_gmt-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

fdomainc-get-rid-of-unused-stuff.patch
