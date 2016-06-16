From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 16 Jun 2016 13:26:37 -0700
Message-ID: <57630b7d.SzFkF/9vN5kf0vKx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbcFPU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 16:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

