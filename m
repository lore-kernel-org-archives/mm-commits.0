From: akpm@linux-foundation.org
Subject: [merged] maintainers-set-up-proper-record-for-xilinx-zynq.patch
 removed from -mm tree
Date: Fri, 03 Jan 2014 12:38:04 -0800
Message-ID: <52c71fac.p3Z8mjS6c/+JGgAf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaACUiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 15:38:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michal.simek@xilinx.com

Subject: [merged] maintainers-set-up-proper-record-for-xilinx-zynq.patch removed from -mm tree
To: michal.simek@xilinx.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 12:38:04 -0800


The patch titled
     Subject: MAINTAINERS: set up proper record for Xilinx Zynq
has been removed from the -mm tree.  Its filename was
     maintainers-set-up-proper-record-for-xilinx-zynq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: MAINTAINERS: set up proper record for Xilinx Zynq

Setup correct zynq entry.
- Add missing cadence_ttc_timer maintainership
- Add zynq wildcard
- Add xilinx wildcard

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~maintainers-set-up-proper-record-for-xilinx-zynq MAINTAINERS
--- a/MAINTAINERS~maintainers-set-up-proper-record-for-xilinx-zynq
+++ a/MAINTAINERS
@@ -1368,6 +1368,9 @@ T:	git git://git.xilinx.com/linux-xlnx.g
 S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
+N:	zynq
+N:	xilinx
+F:	drivers/clocksource/cadence_ttc_timer.c
 
 ARM SMMU DRIVER
 M:	Will Deacon <will.deacon@arm.com>
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
microblaze-extable-sort-the-exception-table-at-build-time.patch
linux-next.patch

