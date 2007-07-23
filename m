From: akpm@linux-foundation.org
Subject: + clean-up-duplicate-includes-in-net-netfilter.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:16:29 -0700
Message-ID: <200707232316.l6NNGT6Z017139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713AbXGWX0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, kaber@trash.net


The patch titled
     Clean up duplicate includes in net/netfilter/
has been added to the -mm tree.  Its filename is
     clean-up-duplicate-includes-in-net-netfilter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
clean-up-duplicate-includes-in-drivers-input.patch
clean-up-duplicate-includes-in-drivers-media.patch
clean-up-duplicate-includes-in-drivers-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-spi.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-fs-gfs2.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
clean-up-duplicate-includes-in-include-media.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-sound-core.patch
clean-up-duplicate-includes-in-sound-ppc.patch
clean-up-duplicate-includes-in-sound-soc.patch
