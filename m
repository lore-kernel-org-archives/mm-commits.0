Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF52C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C27A6611AB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbhDPSM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239524AbhDPSM6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 14:12:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9FBE613B0;
        Fri, 16 Apr 2021 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618596752;
        bh=ZrH704g3uasHvScNTZXkjhjdZZa5tF2OYsSMs8jNOM8=;
        h=Date:From:To:Subject:From;
        b=Bc9ickrpVywP6zLgDHcEgqnI0dnekTW/TSQ/ugdOxZbQTuGG+Wgrn1bAaRjDuUt+H
         SDLedKUgqgDTqcCyBe0AwxkTRY9eYFRy4OD6cUrJnguQ0TyaoIV2uglRgR+CCtaIpE
         EgyMJYOI18MOcHj6mkdBkH0DKzOPHFXbSHxR3u5s=
Date:   Fri, 16 Apr 2021 11:12:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com, osalvador@suse.de
Subject:  [to-be-updated]
 arm64-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from
 -mm tree
Message-ID: <20210416181232.f5_4p%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

Link: https://lkml.kernel.org/r/20210319092635.6214-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

