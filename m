From: akpm@linux-foundation.org
Subject: + dmi-fix-kernel-doc-notation.patch added to -mm tree
Date: Mon, 05 Jan 2009 14:41:39 -0800
Message-ID: <200901052241.n05MfdWZ005227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbZAEWmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 17:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     dmi: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     dmi-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
dmi-fix-kernel-doc-notation.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
docs-add-more-early-params-to-kernel-parameterstxt.patch
doc-reformat-some-long-lines-in-kernel-parameterstxt.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

