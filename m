From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 20 Jun 2016 12:56:57 -0700
Message-ID: <57684a89.KF76o2Ar+5PtWtRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbcFTT47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jun 2016 15:56:59 -0400
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

 tools/virtio/ringtest/Makefile |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN tools/virtio/ringtest/Makefile~linux-next-git-rejects tools/virtio/ringtest/Makefile
--- a/tools/virtio/ringtest/Makefile~linux-next-git-rejects
+++ a/tools/virtio/ringtest/Makefile
@@ -1,10 +1,6 @@
 all:
 
-<<<<<<< HEAD
-all: ring virtio_ring_0_9 virtio_ring_poll virtio_ring_inorder noring
-=======
 all: ring virtio_ring_0_9 virtio_ring_poll virtio_ring_inorder ptr_ring noring
->>>>>>> linux-next/akpm-base
 
 CFLAGS += -Wall
 CFLAGS += -pthread -O2 -ggdb
@@ -20,10 +16,7 @@ ring: ring.o main.o
 virtio_ring_0_9: virtio_ring_0_9.o main.o
 virtio_ring_poll: virtio_ring_poll.o main.o
 virtio_ring_inorder: virtio_ring_inorder.o main.o
-<<<<<<< HEAD
-=======
 ptr_ring: ptr_ring.o main.o
->>>>>>> linux-next/akpm-base
 noring: noring.o main.o
 clean:
 	-rm main.o
@@ -31,10 +24,7 @@ clean:
 	-rm virtio_ring_0_9.o virtio_ring_0_9
 	-rm virtio_ring_poll.o virtio_ring_poll
 	-rm virtio_ring_inorder.o virtio_ring_inorder
-<<<<<<< HEAD
-=======
 	-rm ptr_ring.o ptr_ring
->>>>>>> linux-next/akpm-base
 	-rm noring.o noring
 
 .PHONY: all clean
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

