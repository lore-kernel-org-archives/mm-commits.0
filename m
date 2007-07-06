From: akpm@linux-foundation.org
Subject: + nls-remove-obsolete-makefile-entries.patch added to -mm tree
Date: Fri, 06 Jul 2007 11:04:01 -0700
Message-ID: <200707061804.l66I41hT011520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763467AbXGFSEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 14:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     NLS: Remove obsolete Makefile entries
has been added to the -mm tree.  Its filename is
     nls-remove-obsolete-makefile-entries.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NLS: Remove obsolete Makefile entries
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since the corresponding source files no longer exist, remove the
irrelevant Makefile entries for them.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nls/Makefile |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/nls/Makefile~nls-remove-obsolete-makefile-entries fs/nls/Makefile
--- a/fs/nls/Makefile~nls-remove-obsolete-makefile-entries
+++ a/fs/nls/Makefile
@@ -36,11 +36,9 @@ obj-$(CONFIG_NLS_ISO8859_6)	+= nls_iso88
 obj-$(CONFIG_NLS_ISO8859_7)	+= nls_iso8859-7.o
 obj-$(CONFIG_NLS_ISO8859_8)	+= nls_cp1255.o
 obj-$(CONFIG_NLS_ISO8859_9)	+= nls_iso8859-9.o
-obj-$(CONFIG_NLS_ISO8859_10)	+= nls_iso8859-10.o
 obj-$(CONFIG_NLS_ISO8859_13)	+= nls_iso8859-13.o
 obj-$(CONFIG_NLS_ISO8859_14)	+= nls_iso8859-14.o
 obj-$(CONFIG_NLS_ISO8859_15)	+= nls_iso8859-15.o
 obj-$(CONFIG_NLS_KOI8_R)	+= nls_koi8-r.o
 obj-$(CONFIG_NLS_KOI8_U)	+= nls_koi8-u.o nls_koi8-ru.o
-obj-$(CONFIG_NLS_ABC)		+= nls_abc.o
 obj-$(CONFIG_NLS_UTF8)		+= nls_utf8.o
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
sound-remove-unreferenced-header-file-include-sound-wavefront_fxh.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
