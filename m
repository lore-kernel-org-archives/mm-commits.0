From: akpm@linux-foundation.org
Subject: [patch 034/114] MAINTAINERS: update sboyd's email address
Date: Tue, 06 Feb 2018 15:37:59 -0800
Message-ID: <20180206233759.OlW-epc0q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXiA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sboyd@codeaurora.org, torvalds@linux-foundation.org

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
