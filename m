From: akpm@linux-foundation.org
Subject: [merged] power-fix-kernel-doc-notation.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:32 -0800
Message-ID: <201001112018.o0BKIW54025494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017Ab0AKUT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     power: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     power-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Warning(drivers/base/power/main.c:453): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:453): No description found for parameter 'cb'
Warning(drivers/base/power/main.c:719): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:719): No description found for parameter 'state'
Warning(drivers/base/power/main.c:719): No description found for parameter 'cb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/base/power/main.c~power-fix-kernel-doc-notation drivers/base/power/main.c
--- a/drivers/base/power/main.c~power-fix-kernel-doc-notation
+++ a/drivers/base/power/main.c
@@ -446,8 +446,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
  * legacy_resume - Execute a legacy (bus or class) resume callback for device.
- * dev: Device to resume.
- * cb: Resume callback to execute.
+ * @dev: Device to resume.
+ * @cb: Resume callback to execute.
  */
 static int legacy_resume(struct device *dev, int (*cb)(struct device *dev))
 {
@@ -711,8 +711,9 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
 /**
  * legacy_suspend - Execute a legacy (bus or class) suspend callback for device.
- * dev: Device to suspend.
- * cb: Suspend callback to execute.
+ * @dev: Device to suspend.
+ * @state: PM transition of the system being carried out.
+ * @cb: Suspend callback to execute.
  */
 static int legacy_suspend(struct device *dev, pm_message_t state,
 			  int (*cb)(struct device *dev, pm_message_t state))
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

