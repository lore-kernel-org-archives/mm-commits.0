Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76658C43462
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55AAF6144A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhDVETn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhDVET3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D66776144A;
        Thu, 22 Apr 2021 04:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619065118;
        bh=60HBevSqAN3x9hmoxHG8frGB6SflDmqh7f85MeL3awg=;
        h=Date:From:To:Subject:From;
        b=cq+EU7/ZvtPc44szKzpZVU+goLlH0U3qMZ4Jv5OG9wOSndO5VWcsrRikjU7q4ENe/
         yAzbF/4l5vRZE3dMr+F44zaY378+MQGE9qROLkoyQGNSU50mpYYtry9y4bX2xasu1t
         YK1o0GK9s8YtCzwsaMU1WJwXlCiikWceRKQh9uok=
Date:   Wed, 21 Apr 2021 21:18:37 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [to-be-updated]
 arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from
 -mm tree
Message-ID: <20210422041837.eizUQ98z-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
has been removed from the -mm tree.  Its filename was
     arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable arm64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210416112411.9826-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Kconfig~arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/arm64/Kconfig
@@ -312,6 +312,9 @@ config ZONE_DMA32
 	bool "Support DMA32 zone" if EXPERT
 	default y
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config SMP
 	def_bool y
 
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mmhugetlb-drop-clearing-of-flag-from-prep_new_huge_page.patch
mmhugetlb-split-prep_new_huge_page-functionality.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

