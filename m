From: akpm@linux-foundation.org
Subject: + build-superh-without-config_expert.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:04:42 -0800
Message-ID: <54b5b29a.9cQbDWi3xJHtVNNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbANAEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, geert+renesas@glider.be, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: build superh without CONFIG_EXPERT.
has been added to the -mm tree.  Its filename is
     build-superh-without-config_expert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/build-superh-without-config_expert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/build-superh-without-config_expert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: sh: build superh without CONFIG_EXPERT.

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

x86-build-replace-perl-script-with-shell-script.patch
build-superh-without-config_expert.patch
init-remove-config_init_fallback.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
linux-next.patch
dt-bindings-use-isil-prefix-for-intersil.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch

