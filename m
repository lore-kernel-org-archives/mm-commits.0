From: akpm@linux-foundation.org
Subject: + maintainers-set-up-proper-record-for-xilinx-zynq.patch added to -mm tree
Date: Thu, 19 Dec 2013 14:20:47 -0800
Message-ID: <52b3713f.754CgfXsZu/2fxr1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3LSWUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 17:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, michal.simek@xilinx.com

Subject: + maintainers-set-up-proper-record-for-xilinx-zynq.patch added to -mm tree
To: michal.simek@xilinx.com
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 14:20:47 -0800


The patch titled
     Subject: MAINTAINERS: set up proper record for Xilinx Zynq
has been added to the -mm tree.  Its filename is
     maintainers-set-up-proper-record-for-xilinx-zynq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-set-up-proper-record-for-xilinx-zynq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-set-up-proper-record-for-xilinx-zynq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1366,6 +1366,9 @@ T:	git git://git.xilinx.com/linux-xlnx.g
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

maintainers-set-up-proper-record-for-xilinx-zynq.patch
linux-next.patch

