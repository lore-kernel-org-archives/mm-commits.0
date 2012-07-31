From: akpm@linux-foundation.org
Subject: [merged] clk-remove-redundant-depends-on-from-drivers-kconfig.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:48:17 -0700
Message-ID: <20120731184817.F05F21E0072@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2GaSsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:19 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, andrew@lunn.ch, bhupesh.sharma@st.com, gregkh@linuxfoundation.org, jgarzik@redhat.com, mturquette@linaro.org, peppe.cavallaro@st.com, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, viresh.linux@gmail.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: remove redundant depends on from drivers/Kconfig
has been removed from the -mm tree.  Its filename was
     clk-remove-redundant-depends-on-from-drivers-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: clk: remove redundant depends on from drivers/Kconfig

menu "Common Clock Framework" has "depends on COMMON_CLK" and so configs
defined within menu don't require these "depends on COMMON_CLK again".

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: viresh kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/clk/Kconfig~clk-remove-redundant-depends-on-from-drivers-kconfig drivers/clk/Kconfig
--- a/drivers/clk/Kconfig~clk-remove-redundant-depends-on-from-drivers-kconfig
+++ a/drivers/clk/Kconfig
@@ -25,7 +25,6 @@ menu "Common Clock Framework"
 
 config COMMON_CLK_DEBUG
 	bool "DebugFS representation of clock tree"
-	depends on COMMON_CLK
 	select DEBUG_FS
 	---help---
 	  Creates a directory hierchy in debugfs for visualizing the clk
_

Patches currently in -mm which might be from viresh.kumar@st.com are

origin.patch
linux-next.patch

