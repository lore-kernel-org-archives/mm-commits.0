From: akpm@linux-foundation.org
Subject: - dmi-fix-kernel-doc-notation.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:36 -0800
Message-ID: <200901072217.n07MHaOW017182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563AbZAGWdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dmi: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     dmi-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation:

drivers/firmware/dmi_scan.c:475: No description found for parameter 'str'
drivers/firmware/dmi_scan.c:592: No description found for parameter 'f'
drivers/firmware/dmi_scan.c:592: No description found for parameter 'str'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-fix-kernel-doc-notation drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-fix-kernel-doc-notation
+++ a/drivers/firmware/dmi_scan.c
@@ -468,8 +468,8 @@ const char *dmi_get_system_info(int fiel
 EXPORT_SYMBOL(dmi_get_system_info);
 
 /**
- *	dmi_name_in_serial - 	Check if string is in the DMI product serial
- *				information.
+ * dmi_name_in_serial - Check if string is in the DMI product serial information
+ * @str: string to check for
  */
 int dmi_name_in_serial(const char *str)
 {
@@ -585,6 +585,8 @@ EXPORT_SYMBOL_GPL(dmi_walk);
 
 /**
  * dmi_match - compare a string to the dmi field (if exists)
+ * @f: DMI field identifier
+ * @str: string to compare the DMI field to
  *
  * Returns true if the requested field equals to the str (including NULL).
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

