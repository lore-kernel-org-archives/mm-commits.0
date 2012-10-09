From: akpm@linux-foundation.org
Subject: [merged] mm-document-pagehuge-somewhat.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:15:11 -0700
Message-ID: <20121009181511.B4314100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:37483 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2JISPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:15:12 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so519302qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:15:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document PageHuge somewhat
has been removed from the -mm tree.  Its filename was
     mm-document-pagehuge-somewhat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: document PageHuge somewhat

Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/hugetlb.c~mm-document-pagehuge-somewhat mm/hugetlb.c
--- a/mm/hugetlb.c~mm-document-pagehuge-somewhat
+++ a/mm/hugetlb.c
@@ -671,6 +671,11 @@ static void prep_compound_gigantic_page(
 	}
 }
 
+/*
+ * PageHuge() only returns true for hugetlbfs pages, but not for normal or
+ * transparent huge pages.  See the PageTransHuge() documentation for more
+ * details.
+ */
 int PageHuge(struct page *page)
 {
 	compound_page_dtor *dtor;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
fs-block_devc-set_blocksize-use-mapping_mapped.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

