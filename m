From: akpm@linux-foundation.org
Subject: + maintainers-update-sboyds-email-address.patch added to -mm tree
Date: Mon, 29 Jan 2018 14:37:23 -0800
Message-ID: <5a6fa223.RbZl2bi9KnCVdzo3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbeA2WhY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 17:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update sboyd's email address
has been added to the -mm tree.  Its filename is
     maintainers-update-sboyds-email-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-sboyds-email-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-sboyds-email-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3549,7 +3549,7 @@ F:	drivers/media/platform/coda/
 
 COMMON CLK FRAMEWORK
 M:	Michael Turquette <mturquette@baylibre.com>
-M:	Stephen Boyd <sboyd@codeaurora.org>
+M:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-clk@vger.kernel.org
 Q:	http://patchwork.kernel.org/project/linux-clk/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git
@@ -10160,7 +10160,7 @@ F:	include/uapi/linux/openvswitch.h
 OPERATING PERFORMANCE POINTS (OPP)
 M:	Viresh Kumar <vireshk@kernel.org>
 M:	Nishanth Menon <nm@ti.com>
-M:	Stephen Boyd <sboyd@codeaurora.org>
+M:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vireshk/pm.git
@@ -12827,7 +12827,7 @@ F:	Documentation/networking/spider_net.t
 F:	drivers/net/ethernet/toshiba/spider_net*
 
 SPMI SUBSYSTEM
-R:	Stephen Boyd <sboyd@codeaurora.org>
+R:	Stephen Boyd <sboyd@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 F:	Documentation/devicetree/bindings/spmi/
 F:	drivers/spmi/
@@ -13705,7 +13705,7 @@ F:	include/linux/usb/tilegx.h
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

maintainers-update-sboyds-email-address.patch

