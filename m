From: akpm@linux-foundation.org
Subject: - loosen-dependancy-on-rtc-cmos.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:04 -0800
Message-ID: <200702211046.l1LAk4Ph006434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964889AbXBUKq2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     loosen dependancy on rtc cmos
has been removed from the -mm tree.  Its filename was
     loosen-dependancy-on-rtc-cmos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: loosen dependancy on rtc cmos
From: Dave Jones <davej@redhat.com>

This option is useful for all of the X86 subarchs afaik (and especially
X86_GENERICARCH).

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~loosen-dependancy-on-rtc-cmos drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~loosen-dependancy-on-rtc-cmos
+++ a/drivers/rtc/Kconfig
@@ -101,7 +101,7 @@ comment "RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS' real time clock"
-	depends on RTC_CLASS && (X86_PC || ALPHA || ARM26 || ARM \
+	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
 		|| M32R || ATARI || POWERPC)
 	help
 	  Say "yes" here to get direct support for the real time clock
_

Patches currently in -mm which might be from davej@redhat.com are

git-agpgart.patch
git-cpufreq.patch
