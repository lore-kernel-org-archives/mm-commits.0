From: akpm@linux-foundation.org
Subject: [folded-merged] ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:47:51 -0800
Message-ID: <20130228004751.E81735A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59512 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3B1Arx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:47:53 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so139631ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:47:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, festevam@gmail.com, matt.fleming@intel.com, pjones@redhat.com, swarren@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix
has been removed from the -mm tree.  Its filename was
     ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch

This patch was dropped because it was folded into ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix

fix printk warning

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/partitions/efi.c~ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix block/partitions/efi.c
--- a/block/partitions/efi.c~ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix
+++ a/block/partitions/efi.c
@@ -321,7 +321,7 @@ static int is_gpt_valid(struct parsed_pa
 
 	/* Check the GUID Partition Table header size is too small */
 	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
-		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
+		pr_debug("GUID Partition Table Header size is too small: %u < %zu\n",
 			le32_to_cpu((*gpt)->header_size),
 			sizeof(gpt_header));
 		goto fail;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

