From: akpm@linux-foundation.org
Subject: + i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:42:54 -0700
Message-ID: <200706252242.l5PMgsZd012823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbXFYWnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:43:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     i386 uaccess.h: replace hard-coded constant with appropriate macro from kernel.h
has been added to the -mm tree.  Its filename is
     i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 uaccess.h: replace hard-coded constant with appropriate macro from kernel.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/uaccess.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/uaccess.h~i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh
+++ a/include/asm-i386/uaccess.h
@@ -581,7 +581,7 @@ long __must_check __strncpy_from_user(ch
  * If there is a limit on the length of a valid string, you may wish to
  * consider using strnlen_user() instead.
  */
-#define strlen_user(str) strnlen_user(str, ~0UL >> 1)
+#define strlen_user(str) strnlen_user(str, LONG_MAX)
 
 long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
