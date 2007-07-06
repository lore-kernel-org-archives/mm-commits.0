From: akpm@linux-foundation.org
Subject: + rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch added to -mm tree
Date: Fri, 06 Jul 2007 11:03:35 -0700
Message-ID: <200707061803.l66I3ZAv011509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761735AbXGFSD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 14:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     RPC: Remove Makefile reference to obsolete RXRPC config variable
has been added to the -mm tree.  Its filename is
     rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RPC: Remove Makefile reference to obsolete RXRPC config variable
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since there is no Kconfig variable RXRPC anywhere in the tree, and the
variable AF_RXRPC performs exactly the same function, remove the reference
to CONFIG_RXRPC from net/Makefile.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff -puN net/Makefile~rpc-remove-makefile-reference-to-obsolete-rxrpc-config net/Makefile
--- a/net/Makefile~rpc-remove-makefile-reference-to-obsolete-rxrpc-config
+++ a/net/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_AX25)		+= ax25/
 obj-$(CONFIG_IRDA)		+= irda/
 obj-$(CONFIG_BT)		+= bluetooth/
 obj-$(CONFIG_SUNRPC)		+= sunrpc/
-obj-$(CONFIG_RXRPC)		+= rxrpc/
 obj-$(CONFIG_AF_RXRPC)		+= rxrpc/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_DECNET)		+= decnet/
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
