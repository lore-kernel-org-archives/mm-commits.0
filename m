From: akpm@linux-foundation.org
Subject: - uml-document-new-ubd-flag.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:27 -0800
Message-ID: <200802052235.m15MZ8iC012588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762367AbYBEWlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: document new ubd flag
has been removed from the -mm tree.  Its filename was
     uml-document-new-ubd-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: document new ubd flag
From: Jeff Dike <jdike@addtoit.com>

The ubd help message didn't document the 'c' flag.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-document-new-ubd-flag arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-document-new-ubd-flag
+++ a/arch/um/drivers/ubd_kern.c
@@ -437,7 +437,10 @@ __uml_help(ubd_setup,
 "    machine by running 'dd' on the device. <n> must be in the range\n"
 "    0 to 7. Appending an 'r' to the number will cause that device\n"
 "    to be mounted read-only. For example ubd1r=./ext_fs. Appending\n"
-"    an 's' will cause data to be written to disk on the host immediately.\n\n"
+"    an 's' will cause data to be written to disk on the host immediately.\n"
+"    'c' will cause the device to be treated as being shared between multiple\n"
+"    UMLs and file locking will be turned off - this is appropriate for a\n"
+"    cluster filesystem and inappropriate at almost all other times.\n\n"
 );
 
 static int udb_setup(char *str)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
