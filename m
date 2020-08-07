Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D294AC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B33B62086A
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779300;
	bh=m3TRKGG0rVtUM7dxhUWtVm3d98wJ/XZmDKSMD0qSoIs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uFbsHgbK+LcutR+AW7QVmEoNCjRBlB6d5Oqxdk8YSkVu0n0j+mbYSJdHl5LatNvlo
	 AXF32PdkjJyzTmVGRDGmYWpjIy3q43sYDRD2XFK0flWLL8sotUE50BYIVYcTB4QX6c
	 y4pIkPEx7OlTaRoI9jGVMmhc9q4Pnl0Dyrx0f9cI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFsU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:48:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C0E820866;
        Fri,  7 Aug 2020 05:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779299;
        bh=m3TRKGG0rVtUM7dxhUWtVm3d98wJ/XZmDKSMD0qSoIs=;
        h=Date:From:To:Subject:From;
        b=RNo1zdL5Kvgvc22xd22X2hRhIGu8rNpEpBuPknJsrbh7rs+71ZNUg7lYz8noOkmO5
         scIolAg0j8f417oaygjam7RMPoHHBC9IZgMWDMAbf+GfnJq9xQdeFzFeAqDZdupQB7
         t2381z2o0KYoFnaNNxwwTD5g0QBH22STHwIcIWrw=
Date:   Thu, 06 Aug 2020 22:48:18 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        corbet@lwn.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        hpa@zytor.com, kirill@shutemov.name, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, rppt@kernel.org,
        rppt@linux.ibm.com, tglx@linutronix.de, vgupta@synopsys.com,
        will@kernel.org, ziy@nvidia.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-debug=5Fvm=5Fpgtable-add-tests-validating-advanced-arch?=
 =?US-ASCII?Q?-page-table-helpers-v5.patch?= removed from -mm tree
Message-ID: <20200807054818.Zckq9C-SM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5.patch

This patch was dropped because it was folded into mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5

drop RANDOM_ORVALUE from hugetlb_advanced_tests()

Link: http://lkml.kernel.org/r/1594610587-4172-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: Vineet Gupta <vgupta@synopsys.com>	[arc]
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers-v5
+++ a/mm/debug_vm_pgtable.c
@@ -745,7 +745,7 @@ static void __init hugetlb_advanced_test
 {
 	struct page *page = pfn_to_page(pfn);
 	pte_t pte = ptep_get(ptep);
-	unsigned long paddr = (__pfn_to_phys(pfn) | RANDOM_ORVALUE) & PMD_MASK;
+	unsigned long paddr = __pfn_to_phys(pfn) & PMD_MASK;
 
 	pte = pte_mkhuge(mk_pte(pfn_to_page(PHYS_PFN(paddr)), prot));
 	set_huge_pte_at(mm, vaddr, ptep, pte);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-add-tests-validating-arch-helpers-for-core-mm-features.patch
mm-debug_vm_pgtable-add-tests-validating-advanced-arch-page-table-helpers.patch
mm-debug_vm_pgtable-add-debug-prints-for-individual-tests.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers.patch
documentation-mm-add-descriptions-for-arch-page-table-helpers-v5.patch
mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_populate_basepages.patch
mm-sparsemem-enable-vmem_altmap-support-in-vmemmap_alloc_block_buf.patch
arm64-mm-enable-vmem_altmap-support-for-vmemmap-mappings.patch
mm-vmstat-add-events-for-thp-migration-without-split.patch

