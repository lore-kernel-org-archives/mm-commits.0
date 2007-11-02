From: akpm@linux-foundation.org
Subject: + uml-document-new-ubd-flag.patch added to -mm tree
Date: Fri, 02 Nov 2007 11:42:03 -0700
Message-ID: <200711021842.lA2Ig3Fs005875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525AbXKBSmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 14:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: document new ubd flag
has been added to the -mm tree.  Its filename is
     uml-document-new-ubd-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
