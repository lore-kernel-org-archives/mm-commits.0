From: akpm@linux-foundation.org
Subject: [to-be-updated] kvm-stop-including-asm-generic-bitops-leh.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:02 -0800
Message-ID: <201101131946.p0DJkgUA028780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825Ab1AMTqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kvm: stop including asm-generic/bitops/le.h
has been removed from the -mm tree.  Its filename was
     kvm-stop-including-asm-generic-bitops-leh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: stop including asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>

No need to include asm-generic/bitops/le.h as all architectures provide
little-endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN virt/kvm/kvm_main.c~kvm-stop-including-asm-generic-bitops-leh virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-stop-including-asm-generic-bitops-leh
+++ a/virt/kvm/kvm_main.c
@@ -52,7 +52,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm-generic/bitops/le.h>
 
 #include "coalesced_mmio.h"
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
asm-generic-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bit-operations.patch
dm-use-little-endian-bit-operations.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch
bitops-use-find_first_zero_bit-instead-of-find_next_zero_bitaddr-size-0.patch
spufs-use-simple_write_to_buffer.patch

