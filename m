From: akpm@linux-foundation.org
Subject: + nfsctl-add-headers-for-credentials.patch added to -mm tree
Date: Wed, 19 Nov 2008 11:46:37 -0800
Message-ID: <200811191946.mAJJkbH3007757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbYKSTr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 14:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     nfsctl: add headers for credentials
has been added to the -mm tree.  Its filename is
     nfsctl-add-headers-for-credentials.patch

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
Subject: nfsctl: add headers for credentials
From: Randy Dunlap <randy.dunlap@oracle.com>

Needs headers help for current_cred:

Adding only cred.h wasn't enough.

linux-next-20081023/fs/nfsctl.c:45: error: implicit declaration of function 'current_cred'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/nfsctl.c~nfsctl-add-headers-for-credentials fs/nfsctl.c
--- a/fs/nfsctl.c~nfsctl-add-headers-for-credentials
+++ a/fs/nfsctl.c
@@ -10,6 +10,8 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/syscall.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
 #include <linux/linkage.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

documentation-kernel-parameterstxt-add-min_addr-fix-max_addr.patch
linux-next.patch
coda-fix-creds-reference.patch
nfsctl-add-headers-for-credentials.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
cciss-fix-debug-printk-formats.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

