From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-brcm-dts-pattern.patch removed from
 -mm tree
Date: Mon, 06 Jul 2015 12:48:05 -0700
Message-ID: <559adb75.J97K9iONmRB4diNJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbbGFTsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, abrestic@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update brcm dts pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-brcm-dts-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update brcm dts pattern

Commit 8c0b9ee8665c ("MIPS: Move device-trees into vendor
sub-directories") moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-brcm-dts-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-brcm-dts-pattern
+++ a/MAINTAINERS
@@ -2280,7 +2280,7 @@ S:	Maintained
 F:	arch/mips/bmips/*
 F:	arch/mips/include/asm/mach-bmips/*
 F:	arch/mips/kernel/*bmips*
-F:	arch/mips/boot/dts/bcm*.dts*
+F:	arch/mips/boot/dts/brcm/bcm*.dts*
 F:	drivers/irqchip/irq-bcm7*
 F:	drivers/irqchip/irq-brcmstb*
 
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

