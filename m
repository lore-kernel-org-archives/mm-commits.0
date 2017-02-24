From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:25:02 -0800
Message-ID: <58b0b2be.DSvIsRUoKjmt1Oho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdBXWZD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:25:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, borntraeger@de.ibm.com, hughd@google.com, imbrenda@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix
has been removed from the -mm tree.  Its filename was
     mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix.patch

This patch was dropped because it was folded into mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix

make zero_checksum and ksm_use_zero_pages __read_mostly, per Andrea

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix mm/ksm.c
--- a/mm/ksm.c~mm-ksm-improve-deduplication-of-zero-pages-with-colouring-fix
+++ a/mm/ksm.c
@@ -224,10 +224,10 @@ static unsigned int ksm_thread_pages_to_
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
 /* Checksum of an empty (zeroed) page */
-static unsigned int zero_checksum;
+static unsigned int zero_checksum __read_mostly;
 
 /* Whether to merge empty (zeroed) pages with actual zero pages */
-static bool ksm_use_zero_pages;
+static bool ksm_use_zero_pages __read_mostly;
 
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-ksm-improve-deduplication-of-zero-pages-with-colouring.patch
mm-memory_hotplugc-unexport-__remove_pages.patch
z3fold-add-kref-refcounting-checkpatch-fixes.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk-checkpatch-fixes.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix.patch
mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
lib-update-lz4-compressor-module.patch
lib-update-lz4-compressor-module-fix-fix.patch
lib-update-lz4-compressor-module-fix-fix-fix.patch

