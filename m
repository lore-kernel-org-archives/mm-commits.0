Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17BCC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 15:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A6F61957
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 15:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCSPpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhCSPpJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 11:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8062261954;
        Fri, 19 Mar 2021 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616168709;
        bh=5ZlIi7/cbnpAkJxKlxRgTZEiLcU2nijsCb8Qttrx+jk=;
        h=Date:From:To:Subject:From;
        b=CxU45EctNGwOmkcWKc/7d72//bIIXM+HY6CTtvT2voevmStaEIHYvN/huPewPabRU
         3xo7HdJLJuxqFn8iQh32ig+uMOOQEnTmVIWACwyhh/xnQ2TTQxp335vIN1ZuaxJB8l
         PFw6y8/gHZMDt+Pqha60kNoOhl5pqyYrh7kEyCug=
Date:   Fri, 19 Mar 2021 08:45:09 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [to-be-updated]
 arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from
 -mm tree
Message-ID: <20210319154509.5bPKEL3IF%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20210309175546.5877-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Kconfig~arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/arm64/Kconfig
@@ -310,6 +310,9 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 config ARCH_ENABLE_MEMORY_HOTREMOVE
 	def_bool y
 
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
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.patch

