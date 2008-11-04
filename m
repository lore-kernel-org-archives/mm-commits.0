From: akpm@linux-foundation.org
Subject: + kmod-fix-varargs-kernel-doc.patch added to -mm tree
Date: Mon, 03 Nov 2008 16:39:24 -0800
Message-ID: <200811040039.mA40dO1A030559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbYKDAjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 19:39:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, rusty@rustcorp.com.au


The patch titled
     kmod: fix varargs kernel-doc
has been added to the -mm tree.  Its filename is
     kmod-fix-varargs-kernel-doc.patch

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
Subject: kmod: fix varargs kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix varargs kernel-doc format in kmod.c:
Use @... instead of @varargs.

Warning(kernel/kmod.c:67): Excess function parameter or struct member 'varargs' description in 'request_module'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-fix-varargs-kernel-doc kernel/kmod.c
--- a/kernel/kmod.c~kmod-fix-varargs-kernel-doc
+++ a/kernel/kmod.c
@@ -51,8 +51,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sb
 
 /**
  * request_module - try to load a kernel module
- * @fmt:     printf style format string for the name of the module
- * @varargs: arguements as specified in the format string
+ * @fmt: printf style format string for the name of the module
+ * @...: arguments as specified in the format string
  *
  * Load a module using the user mode module loader. The function returns
  * zero on success or a negative errno code on failure. Note that a
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
fusion-remove-excess-kernel-doc-notation.patch
profile-likely-unlikely-macros.patch

