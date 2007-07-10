From: akpm@linux-foundation.org
Subject: - rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:49:19 -0700
Message-ID: <200707101949.l6AJnJ1a026083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760335AbXGJTzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     RPC: Remove Makefile reference to obsolete RXRPC config variable
has been removed from the -mm tree.  Its filename was
     rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 files changed, 1 deletion(-)

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
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-net.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
usb-remove-makefile-reference-to-obsolete-ohci_at91.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
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
