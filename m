From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 25 May 2016 12:12:22 -0700
Message-ID: <5745f916.MSqpmOGzAQiTiwAF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbcEYTMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2016 15:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/virtio/ringtest/Makefile |    7 -------
 1 file changed, 7 deletions(-)

diff -puN tools/virtio/ringtest/Makefile~linux-next-git-rejects tools/virtio/ringtest/Makefile
--- a/tools/virtio/ringtest/Makefile~linux-next-git-rejects
+++ a/tools/virtio/ringtest/Makefile
@@ -1,10 +1,6 @@
 all:
 
-<<<<<<< HEAD
-all: ring virtio_ring_0_9 virtio_ring_poll virtio_ring_inorder
-=======
 all: ring virtio_ring_0_9 virtio_ring_poll virtio_ring_inorder skb_array
->>>>>>> linux-next/akpm-base
 
 CFLAGS += -Wall
 CFLAGS += -pthread -O2 -ggdb
@@ -20,10 +16,7 @@ ring: ring.o main.o
 virtio_ring_0_9: virtio_ring_0_9.o main.o
 virtio_ring_poll: virtio_ring_poll.o main.o
 virtio_ring_inorder: virtio_ring_inorder.o main.o
-<<<<<<< HEAD
-=======
 skb_array: skb_array.o main.o
->>>>>>> linux-next/akpm-base
 clean:
 	-rm main.o
 	-rm ring.o ring
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

