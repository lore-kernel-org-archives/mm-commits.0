From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-sboyds-email-address.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:56:45 -0800
Message-ID: <20180207195645.-5815p9zd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbeBGT4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org


The patch titled
     Subject: MAINTAINERS: update sboyd's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-sboyds-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: MAINTAINERS: update sboyd's email address

Replace my codeaurora.org address with my kernel.org address so that
emails don't bounce.

Link: http://lkml.kernel.org/r/20180129173258.10643-1-sboyd@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-update-sboyds-email-address MAINTAINERS
--- a/MAINTAINERS~maintainers-update-sboyds-email-address
+++ a/MAINTAINERS
@@ -3575,7 +3575,7 @@ F:	drivers/media/platform/coda/
 
 COMMON CLK FRAMEWORK
 M:	Michael Turquette <mturquette@baylibre.com>
-M:	Stephen Boyd <sboyd@codeaurora.org>
+M:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-clk@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-clk/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
@@ -10259,7 +10259,7 @@ F:	include/uapi/linux/openvswitch.h
 OPERATING PERFORMANCE POINTS (OPP)
 M:	Viresh Kumar <vireshk@kernel.org>
 M:	Nishanth Menon <nm@ti.com>
-M:	Stephen Boyd <sboyd@codeaurora.org>
+M:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/pm.git
@@ -12976,7 +12976,7 @@ F:	Documentation/networking/spider_net.t
 F:	drivers/net/ethernet/toshiba/spider_net*
 
 SPMI SUBSYSTEM
-R:	Stephen Boyd <sboyd@codeaurora.org>
+R:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 F:	Documentation/devicetree/bindings/spmi/
 F:	drivers/spmi/
@@ -13859,7 +13859,7 @@ F:	include/linux/usb/tilegx.h
 TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
 M:	John Stultz <john.stultz@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
-R:	Stephen Boyd <sboyd@codeaurora.org>
+R:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
_

Patches currently in -mm which might be from sboyd@codeaurora.org are


