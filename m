From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch removed from -mm
 tree
Date: Wed, 31 May 2017 11:42:34 -0700
Message-ID: <20170531184234.wisfjGjXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60380 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdEaSmg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 14:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, pavel@denx.de, pavel@ucw.cz, robh+dt@kernel.org, sr@denx.de, stable@vger.kernel.org


The patch titled
     Subject: powerpc/sequoia: fix NAND partitions not to overlap
has been removed from the -mm tree.  Its filename was
     powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Machek <pavel@denx.de>
Subject: powerpc/sequoia: fix NAND partitions not to overlap

Fix overlapping NAND partitions.  Two partitions at same place are bad
news...

Link: http://lkml.kernel.org/r/20170402100535.GA18340@amd
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Stefan Roese <sr@denx.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/sequoia.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/boot/dts/sequoia.dts~powerpc-sequoia-fix-nand-partitions-not-to-overlap arch/powerpc/boot/dts/sequoia.dts
--- a/arch/powerpc/boot/dts/sequoia.dts~powerpc-sequoia-fix-nand-partitions-not-to-overlap
+++ a/arch/powerpc/boot/dts/sequoia.dts
@@ -229,7 +229,7 @@
 						};
 						partition@84000 {
 							label = "user";
-							reg = <0x00000000 0x01f7c000>;
+							reg = <0x00084000 0x01f7c000>;
 						};
 					};
 				};
_

Patches currently in -mm which might be from pavel@denx.de are


