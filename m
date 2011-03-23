From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-sharp-lh7a40x-section.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:00 -0700
Message-ID: <201103232043.p2NKhaCB028886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756000Ab1CWUzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove SHARP LH7A40X section
has been removed from the -mm tree.  Its filename was
     maintainers-remove-sharp-lh7a40x-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove SHARP LH7A40X section
From: Joe Perches <joe@perches.com>

commit 82e6923e186 ("ARM: lh7a40x: remove unmaintained platform support")
removed support, remove it from MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-sharp-lh7a40x-section MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-sharp-lh7a40x-section
+++ a/MAINTAINERS
@@ -5651,17 +5651,6 @@ M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
-SHARP LH SUPPORT (LH7952X & LH7A40X)
-M:	Marc Singer <elf@buici.com>
-W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
-F:	arch/arm/mach-lh7a40x/
-F:	drivers/tty/serial/serial_lh7a40x.c
-F:	drivers/usb/gadget/lh7a40*
-F:	drivers/usb/host/ohci-lh7a40*
