From: akpm@linux-foundation.org
Subject: [folded] lib-add-lib-gcdc-fix-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:58:14 -0700
Message-ID: <200906172258.n5HMwEpR017581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZFQXAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 19:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, florian@openwrt.org, horms@verge.net.au, joe@perches.com, juliusv@google.com, kaber@trash.net, sshtylyov@ru.mvista.com, tiwai@suse.de


The patch titled
     lib-add-lib-gcdc-fix-fix
has been removed from the -mm tree.  Its filename was
     lib-add-lib-gcdc-fix-fix.patch

This patch was dropped because it was folded into lib-add-lib-gcdc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-add-lib-gcdc-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

doh.

Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Joe Perches <joe@perches.com>
Cc: Julius Volz <juliusv@google.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/Makefile~lib-add-lib-gcdc-fix-fix lib/Makefile
--- a/lib/Makefile~lib-add-lib-gcdc-fix-fix
+++ a/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o gcd.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o
+	 string_helpers.o gcd.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
lib-add-lib-gcdc.patch
lib-add-lib-gcdc-fix-fix.patch

