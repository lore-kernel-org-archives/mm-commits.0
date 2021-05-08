Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122F3C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E74686142D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWwQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhEHWwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7832761402;
        Sat,  8 May 2021 22:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514273;
        bh=X2AGytv6splG0TM+0g+0HrXyJ3J5Ydib0wMFXXwQwa4=;
        h=Date:From:To:Subject:From;
        b=pOH8OcUN6ARDSf1jO7mC50jmxhVGddNaCj0IFInnLKN9QgdHPbPCN5e+th6D57v30
         /3ZCCiYUnjU7GbFycmiz3VvaXEEhCd3qmombUUErkJQ6UfXlk6o5fo4RqQ/CWD8Ao+
         YO9I3jTJkWGpxIr2Jg8rvWp9kW934e1AyCKwUyKA=
Date:   Sat, 08 May 2021 15:51:13 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from
 -mm tree
Message-ID: <20210508225113.07CZGbrLC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
has been removed from the -mm tree.  Its filename was
     arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arm64/Kconfig: introduce ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE

Enable arm64 platform to use the MHP_MEMMAP_ON_MEMORY feature.

Link: https://lkml.kernel.org/r/20210421102701.25051-9-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Kconfig~arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable
+++ a/arch/arm64/Kconfig
@@ -316,6 +316,9 @@ config ZONE_DMA32
 	bool "Support DMA32 zone" if EXPERT
 	default y
 
+config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
+	def_bool y
+
 config SMP
 	def_bool y
 
_

Patches currently in -mm which might be from osalvador@suse.de are


