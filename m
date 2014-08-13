From: akpm@linux-foundation.org
Subject: + maintainers-assing-systemace-driver-to-xilinx.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 13:42:06 -0700
Message-ID: <53ebcd9e.IMrogyUvxqkR7hsk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:54336 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:42:07 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so39550yha.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:42:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.simek@xilinx.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: assign systemace driver to Xilinx
has been added to the -mm tree.  Its filename is
     maintainers-assing-systemace-driver-to-xilinx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-assing-systemace-driver-to-xilinx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-assing-systemace-driver-to-xilinx.patch

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
@@ -1503,6 +1503,7 @@ T:	git git://git.xilinx.com/linux-xlnx.g
 S:	Supported
 F:	arch/arm/mach-zynq/
 F:	drivers/cpuidle/cpuidle-zynq.c
+F:	drivers/block/xsysace.c
 N:	zynq
 N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
@@ -10100,10 +10101,6 @@ M:	John Linn <John.Linn@xilinx.com>
 S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
-XILINX SYSTEMACE DRIVER
-S:	Orphan
-F:	drivers/block/xsysace.c
