From: akpm@linux-foundation.org
Subject: [merged] net-netfilter-nfnetlink_acctc-use-linux-atomich.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:52 -0700
Message-ID: <20120403201052.BA271A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:43041 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2DCUKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:10:53 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so16618ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, kaber@trash.net, pablo@netfilter.org, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/nfnetlink_acct.c: use linux/atomic.h
has been removed from the -mm tree.  Its filename was
     net-netfilter-nfnetlink_acctc-use-linux-atomich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/netfilter/nfnetlink_acct.c: use linux/atomic.h

There's no known problem here, but this is one of only two non-arch files
in the kernel which use asm/atomic.h instead of linux/atomic.h.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nfnetlink_acct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/netfilter/nfnetlink_acct.c~net-netfilter-nfnetlink_acctc-use-linux-atomich net/netfilter/nfnetlink_acct.c
--- a/net/netfilter/nfnetlink_acct.c~net-netfilter-nfnetlink_acctc-use-linux-atomich
+++ a/net/netfilter/nfnetlink_acct.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/atomic.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
@@ -17,7 +18,6 @@
 #include <linux/errno.h>
 #include <net/netlink.h>
 #include <net/sock.h>
-#include <asm/atomic.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed.patch
fs-xattrc-setxattr-improve-handling-of-allocation-failures.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

