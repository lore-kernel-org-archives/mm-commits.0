From: akpm@linux-foundation.org
Subject: [folded] memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:28:00 -0800
Message-ID: <201101130028.p0D0S0RC012540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1AMA2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:28:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, maximlevitsky@gmail.com, oakad@yahoo.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
has been removed from the -mm tree.  Its filename was
     memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch

This patch was dropped because it was folded into memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/memstick/core/mspro_block.c:1090: warning: format '%x' expects type 'unsigned int', but argument 7 has type 'size_t'

Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix
+++ a/drivers/memstick/core/mspro_block.c
@@ -1051,7 +1051,7 @@ static int mspro_block_read_attributes(s
 		addr = be32_to_cpu(attr->entries[cnt].address);
 		s_attr->size = be32_to_cpu(attr->entries[cnt].size);
 		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
-			"size %x\n", cnt, attr->entries[cnt].id, addr,
+			"size %zx\n", cnt, attr->entries[cnt].id, addr,
 			s_attr->size);
 		s_attr->id = attr->entries[cnt].id;
 		if (mspro_block_attr_name(s_attr->id))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
fs-select-fix-information-leak-to-userspace.patch
drivers-telephony-ixjc-fix-warning.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps.patch
sysctl-remove-obsolete-comments.patch
user_ns-improve-the-user_ns-on-the-slab-packaging.patch
pps-add-parallel-port-pps-signal-generator.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
scatterlist-new-helper-functions-fix.patch
aio-remove-unused-aio_run_iocbs-checkpatch-fixes.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
fs-ext4-inodec-use-pr_warn_ratelimited.patch

