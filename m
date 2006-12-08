From: akpm@osdl.org
Subject: - mbxfb-fix-hscoeff3-register-address.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:35 -0800
Message-ID: <200612082013.kB8KDZuP003105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59705 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946814AbWLHUOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raph@8d.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mbxfb: Fix HSCOEFF3 register address
has been removed from the -mm tree.  Its filename was
     mbxfb-fix-hscoeff3-register-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbxfb: Fix HSCOEFF3 register address
From: Raphael Assenat <raph@8d.com>

This patch corrects the address for register HSCOEFF3.

Signed-off-by: Raphael Assenat <raph@8d.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/mbx/regs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mbx/regs.h~mbxfb-fix-hscoeff3-register-address drivers/video/mbx/regs.h
--- a/drivers/video/mbx/regs.h~mbxfb-fix-hscoeff3-register-address
+++ a/drivers/video/mbx/regs.h
@@ -127,7 +127,7 @@
 #define HSCOEFF0	__REG_2700G(0x000021b4)
 #define HSCOEFF1	__REG_2700G(0x000021b8)
 #define HSCOEFF2	__REG_2700G(0x000021bc)
-#define HSCOEFF3	__REG_2700G(0x000021b0)
+#define HSCOEFF3	__REG_2700G(0x000021c0)
 #define HSCOEFF4	__REG_2700G(0x000021c4)
 #define HSCOEFF5	__REG_2700G(0x000021c8)
 #define HSCOEFF6	__REG_2700G(0x000021cc)
_

Patches currently in -mm which might be from raph@8d.com are

mbxfb-fix-hscoeff3-register-address.patch
mbxfb-add-more-registers-bits.patch
mbxfb-add-more-registers-to-debugfs.patch
mbxfb-add-yuv-video-overlay-support.patch
mbxfb-document-the-new-ioctl.patch

