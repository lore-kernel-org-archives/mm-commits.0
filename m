From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-arch-x86-platform-mrst-pmu.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:32 -0800
Message-ID: <20130107192633.16976200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:45267 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3AGT0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:35 -0500
Received: by mail-la0-f74.google.com with SMTP id ej20so669820lab.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, alan@linux.intel.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove arch/x86/platform/mrst/pmu.*
has been removed from the -mm tree.  Its filename was
     maintainers-remove-arch-x86-platform-mrst-pmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove arch/x86/platform/mrst/pmu.*

These files were removed by commit 1a8359e ("x86/mid: Remove Intel
Moorestown").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-arch-x86-platform-mrst-pmu MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-arch-x86-platform-mrst-pmu
+++ a/MAINTAINERS
@@ -4065,12 +4065,6 @@ F:	Documentation/networking/ixgbe.txt
 F:	Documentation/networking/ixgbevf.txt
 F:	drivers/net/ethernet/intel/
 
-INTEL MRST PMU DRIVER
-M:	Len Brown <len.brown@intel.com>
-L:	linux-pm@vger.kernel.org
-S:	Supported
-F:	arch/x86/platform/mrst/pmu.*
