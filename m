From: akpm@linux-foundation.org
Subject: - embedded-maintainers-linux-embedded-vger-list.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:25 -0700
Message-ID: <200805021942.m42JgPOq011190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932160AbYEBTmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Embedded Maintainer(s), linux-embedded@vger list
has been removed from the -mm tree.  Its filename was
     embedded-maintainers-linux-embedded-vger-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Embedded Maintainer(s), linux-embedded@vger list
From: David Woodhouse <dwmw2@infradead.org>

Add Paul and myself, and the linux-embedded list, to MAINTAINERS.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~embedded-maintainers-linux-embedded-vger-list MAINTAINERS
--- a/MAINTAINERS~embedded-maintainers-linux-embedded-vger-list
+++ a/MAINTAINERS
@@ -1557,6 +1557,14 @@ M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
 
+EMBEDDED LINUX
+P:	Paul Gortmaker
+M:	paul.gortmaker@windriver.com
+P	David Woodhouse
+M:	dwmw2@infradead.org
+L:	linux-embedded@vger.kernel.org
+S:	Maintained
+
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart
 M:	james.smart@emulex.com
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
pmu-battery-filenames-in-sysfs-with-spaces.patch
power_supply-support-serial-number-and-acr-in-olpc_battery.patch
power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch
power_supply-cleanup-of-the-olpc-battery-driver.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

