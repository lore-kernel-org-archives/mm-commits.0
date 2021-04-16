Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6215C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD32613C1
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 19:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbhDPTrU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240723AbhDPTrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 15:47:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFF9613C5;
        Fri, 16 Apr 2021 19:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618602413;
        bh=0YjkRvwFRvSrKEw5TDfyd6yin6OQJ0Bl+hSB1taJBpA=;
        h=Date:From:To:Subject:From;
        b=zJ/z33e8GznaE9nHDww/R191fiSr98r1enLSFXb6/+xoYqEp+s6Jr3S/S7n7heqCh
         0K8yZ36428RF4ibUerAEW9BiJ+xXnOzJT7CVfNt3IMkvOnc8KYLnBPXFK08zynaM0S
         fQYB6znkWTvwXGZp2V9KVTnBgm7skRXRODuojccs=
Date:   Fri, 16 Apr 2021 12:46:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        pasha.tatashin@soleen.com, mhocko@suse.com, mhocko@kernel.org,
        david@redhat.com, anshuman.khandual@arm.com, osalvador@suse.de
Subject:  [to-be-updated]
 x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from -mm
 tree
Message-ID: <20210416194652.TDjsS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
has been removed from the -mm tree.  Its filename was
     x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: x86/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable x86_64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210416112411.9826-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/Kconfig~x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/x86/Kconfig
@@ -2430,6 +2430,9 @@ config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges-fix.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch
arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

