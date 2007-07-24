From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-net-netfilter.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:30 -0700
Message-ID: <200707242325.l6ONPUR0006370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757663AbXGXXgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in net/netfilter/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-net-netfilter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in net/netfilter/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	net/netfilter/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_proto_tcp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udplite.c |    1 -
 net/netfilter/xt_physdev.c                 |    1 -
 4 files changed, 4 deletions(-)

diff -puN net/netfilter/nf_conntrack_proto_tcp.c~clean-up-duplicate-includes-in-net-netfilter net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c~clean-up-duplicate-includes-in-net-netfilter
+++ a/net/netfilter/nf_conntrack_proto_tcp.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
diff -puN net/netfilter/nf_conntrack_proto_udp.c~clean-up-duplicate-includes-in-net-netfilter net/netfilter/nf_conntrack_proto_udp.c
--- a/net/netfilter/nf_conntrack_proto_udp.c~clean-up-duplicate-includes-in-net-netfilter
+++ a/net/netfilter/nf_conntrack_proto_udp.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff -puN net/netfilter/nf_conntrack_proto_udplite.c~clean-up-duplicate-includes-in-net-netfilter net/netfilter/nf_conntrack_proto_udplite.c
--- a/net/netfilter/nf_conntrack_proto_udplite.c~clean-up-duplicate-includes-in-net-netfilter
+++ a/net/netfilter/nf_conntrack_proto_udplite.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff -puN net/netfilter/xt_physdev.c~clean-up-duplicate-includes-in-net-netfilter net/netfilter/xt_physdev.c
--- a/net/netfilter/xt_physdev.c~clean-up-duplicate-includes-in-net-netfilter
+++ a/net/netfilter/xt_physdev.c
@@ -13,7 +13,6 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_bridge.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-dvb.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
clean-up-duplicate-includes-in-drivers-input.patch
git-kbuild.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
git-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-selinux.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
cciss-fix-memory-leak.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
