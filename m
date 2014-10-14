From: akpm@linux-foundation.org
Subject: [merged] maintainers-assing-systemace-driver-to-xilinx.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:09 -0700
Message-ID: <543d691d.oCeWgzWzNQHecH6a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJNSTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@xilinx.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: assign systemace driver to Xilinx
has been removed from the -mm tree.  Its filename was
     maintainers-assing-systemace-driver-to-xilinx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: MAINTAINERS: assign systemace driver to Xilinx

Assign systemace driver to Xilinx Zynq to ensure if there is a change that
someone can even test it.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-assing-systemace-driver-to-xilinx MAINTAINERS
--- a/MAINTAINERS~maintainers-assing-systemace-driver-to-xilinx
+++ a/MAINTAINERS
@@ -1550,6 +1550,7 @@ T:	git git://git.xilinx.com/linux-xlnx.g
 S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
+F:	drivers/block/xsysace.c
 N:	zynq
 N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
@@ -10315,10 +10316,6 @@ M:	John Linn <John.Linn@xilinx.com>
 S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
-XILINX SYSTEMACE DRIVER
-S:	Orphan
-F:	drivers/block/xsysace.c
