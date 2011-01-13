From: akpm@linux-foundation.org
Subject: [to-be-updated] rds-stop-including-asm-generic-bitops-leh.patch removed from -mm tree
Date: Thu, 13 Jan 2011 11:44:00 -0800
Message-ID: <201101131946.p0DJkefb028775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799Ab1AMTqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 14:46:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, andy.grover@oracle.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     rds: stop including asm-generic/bitops/le.h
has been removed from the -mm tree.  Its filename was
     rds-stop-including-asm-generic-bitops-leh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rds: stop including asm-generic/bitops/le.h
From: Akinobu Mita <akinobu.mita@gmail.com>

No need to include asm-generic/bitops/le.h as all architectures provide
little-endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rds/cong.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/rds/cong.c~rds-stop-including-asm-generic-bitops-leh net/rds/cong.c
--- a/net/rds/cong.c~rds-stop-including-asm-generic-bitops-leh
+++ a/net/rds/cong.c
@@ -34,8 +34,6 @@
 #include <linux/types.h>
 #include <linux/rbtree.h>
 
-#include <asm-generic/bitops/le.h>
-
 #include "rds.h"
 
 /*
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
kvm-stop-including-asm-generic-bitops-leh.patch
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

