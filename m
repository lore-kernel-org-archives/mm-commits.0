From: akpm@linux-foundation.org
Subject: - regulator-fixed-regulator-interface.patch removed from -mm tree
Date: Fri, 30 May 2008 16:08:08 -0700
Message-ID: <200805302308.m4UN88WP016214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbYE3XIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 19:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lg@opensource.wolfsonmicro.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     regulator: fixed regulator interface
has been removed from the -mm tree.  Its filename was
     regulator-fixed-regulator-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator: fixed regulator interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>

This patch adds support for fixed regulators.  This class of regulator is not
software controllable but can coexist on machines with software controllable
regulators.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/regulator/fixed.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN /dev/null include/linux/regulator/fixed.h
--- /dev/null
+++ a/include/linux/regulator/fixed.h
@@ -0,0 +1,22 @@
+/*
+ * fixed.h
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef __REGULATOR_FIXED_H
+#define __REGULATOR_FIXED_H
+
+struct fixed_voltage_config {
+	const char *supply_name;
+	int microvolts;
+};
+
+#endif
_

Patches currently in -mm which might be from lg@opensource.wolfsonmicro.com are

linux-next.patch
git-regulator.patch

