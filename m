From: akpm@linux-foundation.org
Subject: [patch 109/114] MAINTAINERS: remove ARM/CLKDEV SUPPORT
 file pattern
Date: Tue, 06 Feb 2018 15:42:26 -0800
Message-ID: <20180206234226.k8S3K3qMg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754145AbeBFXm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:42:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux@armlinux.org.uk, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern

34d2f4d3a4d6 ("ARM: Use generic clkdev.h header") removed the file, remove
the pattern.

Link: http://lkml.kernel.org/r/41bfff9449a5894b94f583983b6c6cb46f4cd821.1517147485.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arm-clkdev-support-file-pattern
+++ a/MAINTAINERS
@@ -1307,7 +1307,6 @@ M:	Russell King <linux@armlinux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.armlinux.org.uk/~rmk/linux-arm.git clkdev
-F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
_
