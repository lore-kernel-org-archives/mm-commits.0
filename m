From: akpm@linux-foundation.org
Subject: + maintainers-correct-rtc-armada38x-pattern-entry.patch added to
 -mm tree
Date: Thu, 12 Mar 2015 13:03:07 -0700
Message-ID: <5501f0fb.Y08T3JwqHyEMZiJK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbbCLUDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregory.clement@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: correct rtc armada38x pattern entry
has been added to the -mm tree.  Its filename is
     maintainers-correct-rtc-armada38x-pattern-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-correct-rtc-armada38x-pattern-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-correct-rtc-armada38x-pattern-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: correct rtc armada38x pattern entry

commit c6a95dbee793 ("MAINTAINERS: add the RTC driver for the Armada38x")
typoed the pattern, fix it.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-correct-rtc-armada38x-pattern-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-correct-rtc-armada38x-pattern-entry
+++ a/MAINTAINERS
@@ -1176,7 +1176,7 @@ M:	Sebastian Hesselbarth <sebastian.hess
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-mvebu/
-F:	drivers/rtc/armada38x-rtc
+F:	drivers/rtc/rtc-armada38x.c
 
 ARM/Marvell Berlin SoC support
 M:	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-correct-rtc-armada38x-pattern-entry.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
linux-next.patch

