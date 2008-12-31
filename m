From: akpm@linux-foundation.org
Subject: + es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch added to -mm tree
Date: Tue, 30 Dec 2008 20:43:31 -0800
Message-ID: <200812310443.mBV4hVB0017878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYLaEnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 23:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, rydberg@euromail.se


The patch titled
     input: fix function arg list
has been added to the -mm tree.  Its filename is
     es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch

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
Subject: input: fix function arg list
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function args build warning:

mmotm-2008-1230-1605/drivers/input/input.c:1661: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/input.c~es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix drivers/input/input.c
--- a/drivers/input/input.c~es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix
+++ a/drivers/input/input.c
@@ -1644,7 +1644,7 @@ static const struct file_operations inpu
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass()
+static void __init input_init_abs_bypass(void)
 {
 	const unsigned int *p;
 	for (p = input_abs_bypass_init_data; *p; p++)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
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

