From: akpm@linux-foundation.org
Subject: [folded-merged] arm64-mm-support-arch_mmap_rnd_bits-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:24:40 -0800
Message-ID: <56982028.da4/sh43D1dt5Ym+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbcANWYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:24:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, dcashman@google.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-mm-support-arch_mmap_rnd_bits-fix
has been removed from the -mm tree.  Its filename was
     arm64-mm-support-arch_mmap_rnd_bits-fix.patch

This patch was dropped because it was folded into arm64-mm-support-arch_mmap_rnd_bits.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arm64-mm-support-arch_mmap_rnd_bits-fix

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Daniel Cashman <dcashman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-fix arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-mm-support-arch_mmap_rnd_bits-fix
+++ a/arch/arm64/mm/mmap.c
@@ -51,7 +51,7 @@ unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
-ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT))
 		rnd = (unsigned long)get_random_int() % (1 << mmap_rnd_compat_bits);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

