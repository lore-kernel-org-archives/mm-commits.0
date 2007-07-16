From: akpm@linux-foundation.org
Subject: - nls-remove-obsolete-makefile-entries.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:51 -0700
Message-ID: <200707162059.l6GKxplq002460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757377AbXGPVHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:07:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     NLS: Remove obsolete Makefile entries
has been removed from the -mm tree.  Its filename was
     nls-remove-obsolete-makefile-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
