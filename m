From: akpm@linux-foundation.org
Subject: [merged] x86-remove-rdc321x_defsh.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:38:07 -0400
Message-ID: <201003261939.o2QJd6pO016796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab0CZTj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian@openwrt.org, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, sameo@linux.intel.com, tglx@linutronix.de, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     x86: remove rdc321x_defs.h
has been removed from the -mm tree.  Its filename was
     x86-remove-rdc321x_defsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove rdc321x_defs.h
From: Florian Fainelli <florian@openwrt.org>

This file is replaced by a cleaner version with the adding of a MFD driver
for the southbridge.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/rdc321x_defs.h |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN arch/x86/include/asm/rdc321x_defs.h~x86-remove-rdc321x_defsh /dev/null
--- a/arch/x86/include/asm/rdc321x_defs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#define PFX	"rdc321x: "
-
-/* General purpose configuration and data registers */
-#define RDC3210_CFGREG_ADDR     0x0CF8
-#define RDC3210_CFGREG_DATA     0x0CFC
-
-#define RDC321X_GPIO_CTRL_REG1	0x48
-#define RDC321X_GPIO_CTRL_REG2	0x84
-#define RDC321X_GPIO_DATA_REG1	0x4c
-#define RDC321X_GPIO_DATA_REG2	0x88
