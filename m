From: akpm@linux-foundation.org
Subject: [merged] maintainers-credits-remove-stefano-brivio-from-b43.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:07 -0700
Message-ID: <552fe96b.sjGq7yfrOsDUoKGb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbbDPQti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: CREDITS: remove Stefano Brivio from B43
has been removed from the -mm tree.  Its filename was
     maintainers-credits-remove-stefano-brivio-from-b43.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -508,6 +508,10 @@ E: paul@paulbristow.net
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
@@ -1915,16 +1915,14 @@ S:	Maintained
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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
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
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

