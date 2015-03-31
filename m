From: akpm@linux-foundation.org
Subject: + maintainers-credits-remove-stefano-brivio-from-b43.patch added
 to -mm tree
Date: Tue, 31 Mar 2015 15:40:23 -0700
Message-ID: <551b2257.yXBjSQgbl7yNuqdN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbCaWkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 18:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: CREDITS: remove Stefano Brivio from B43
has been added to the -mm tree.  Its filename is
     maintainers-credits-remove-stefano-brivio-from-b43.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-credits-remove-stefano-brivio-from-b43.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-credits-remove-stefano-brivio-from-b43.patch

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
Subject: MAINTAINERS: CREDITS: remove Stefano Brivio from B43

This email address isn't working anymore

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN CREDITS~maintainers-credits-remove-stefano-brivio-from-b43 CREDITS
--- a/CREDITS~maintainers-credits-remove-stefano-brivio-from-b43
+++ a/CREDITS
@@ -504,6 +504,10 @@ E: paul@paulbristow.net
 W: http://paulbristow.net/linux/idefloppy.html
 D: Maintainer of IDE/ATAPI floppy driver
 
+N: Stefano Brivio
+E: stefano.brivio@polimi.it
+D: Broadcom B43 driver
+
 N: Dominik Brodowski
 E: linux@brodo.de
 W: http://www.brodo.de/
diff -puN MAINTAINERS~maintainers-credits-remove-stefano-brivio-from-b43 MAINTAINERS
--- a/MAINTAINERS~maintainers-credits-remove-stefano-brivio-from-b43
+++ a/MAINTAINERS
@@ -1914,16 +1914,14 @@ S:	Maintained
 F:	drivers/media/radio/radio-aztech*
 
 B43 WIRELESS DRIVER
-M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
 W:	http://wireless.kernel.org/en/users/Drivers/b43
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/net/wireless/b43/
 
 B43LEGACY WIRELESS DRIVER
 M:	Larry Finger <Larry.Finger@lwfinger.net>
-M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 L:	b43-dev@lists.infradead.org
 W:	http://wireless.kernel.org/en/users/Drivers/b43
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
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
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
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
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-72-columns.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
adfs-returning-correct-return-values.patch
linux-next.patch

