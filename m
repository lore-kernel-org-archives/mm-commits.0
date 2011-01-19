From: akpm@linux-foundation.org
Subject: [folded] scatterlist-new-helper-functions-fix.patch removed from -mm tree
Date: Wed, 19 Jan 2011 13:05:21 -0800
Message-ID: <201101192105.p0JL5Ler003050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525Ab1ASVF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 16:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, maximlevitsky@gmail.com, oakad@yahoo.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     scatterlist-new-helper-functions-fix
has been removed from the -mm tree.  Its filename was
     scatterlist-new-helper-functions-fix.patch

This patch was dropped because it was folded into scatterlist-new-helper-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scatterlist-new-helper-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix general disaster in code comments

Cc: Alex Dubov <oakad@yahoo.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN lib/scatterlist.c~scatterlist-new-helper-functions-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scatterlist-new-helper-functions-fix
+++ a/lib/scatterlist.c
@@ -181,8 +181,14 @@ void sg_init_one(struct scatterlist *sg,
 EXPORT_SYMBOL(sg_init_one);
 
 /**
- * sg_copy - copies sg entries from sg_from to sg_to, such
- * as sg_to covers first 'len' bytes from sg_from.
+ * sg_copy - copy sg entries
+ * @sg_from: source
+ * @sg_to: destination
+ *
+ * Copies from @sg_from to @sg_to.  @sg_to covers first 'len' bytes from
+ * @sg_from.
+ *
+ * Returns zero on success, else a -ve errno.
  */
 int sg_copy(struct scatterlist *sg_from, struct scatterlist *sg_to, int len)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

