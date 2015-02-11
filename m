From: akpm@linux-foundation.org
Subject: [merged] build-superh-without-config_expert.patch removed from
 -mm tree
Date: Wed, 11 Feb 2015 12:20:51 -0800
Message-ID: <54dbb9a3.6G3TKUtezOxzvrax%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbbBKUUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, geert+renesas@glider.be, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: build superh without CONFIG_EXPERT
has been removed from the -mm tree.  Its filename was
     build-superh-without-config_expert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: sh: build superh without CONFIG_EXPERT

What sh4 actually wants is HAVE_PATA_PLATFORM, so select that instead.

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/Kconfig~build-superh-without-config_expert arch/sh/Kconfig
--- a/arch/sh/Kconfig~build-superh-without-config_expert
+++ a/arch/sh/Kconfig
@@ -1,7 +1,7 @@
 config SUPERH
 	def_bool y
 	select ARCH_MIGHT_HAVE_PC_PARPORT
-	select EXPERT
+	select HAVE_PATA_PLATFORM
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT_MAP
 	select HAVE_MEMBLOCK
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
init-remove-config_init_fallback.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
scripts-gdb-add-basic-documentation.patch
linux-next.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch

