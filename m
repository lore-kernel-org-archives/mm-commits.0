From: akpm@linux-foundation.org
Subject: [merged] printk-fix-new-kernel-doc-warnings.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:04 -0800
Message-ID: <200912182027.nBIKR47u016597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802AbZLRU1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     printk: fix new kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     printk-fix-new-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: fix new kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in printk.c:

Warning(kernel/printk.c:1422): No description found for parameter 'dumper'
Warning(kernel/printk.c:1422): Excess function parameter 'dump' description in 'kmsg_dump_register'
Warning(kernel/printk.c:1451): No description found for parameter 'dumper'
Warning(kernel/printk.c:1451): Excess function parameter 'dump' description in 'kmsg_dump_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-fix-new-kernel-doc-warnings kernel/printk.c
--- a/kernel/printk.c~printk-fix-new-kernel-doc-warnings
+++ a/kernel/printk.c
@@ -1412,7 +1412,7 @@ static LIST_HEAD(dump_list);
 
 /**
  * kmsg_dump_register - register a kernel log dumper.
- * @dump: pointer to the kmsg_dumper structure
+ * @dumper: pointer to the kmsg_dumper structure
  *
  * Adds a kernel log dumper to the system. The dump callback in the
  * structure will be called when the kernel oopses or panics and must be
@@ -1442,7 +1442,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_register);
 
 /**
  * kmsg_dump_unregister - unregister a kmsg dumper.
- * @dump: pointer to the kmsg_dumper structure
+ * @dumper: pointer to the kmsg_dumper structure
  *
  * Removes a dump device from the system. Returns zero on success and
  * %-EINVAL otherwise.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
docs-large-update-to-ioctl-numbertxt.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

