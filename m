Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF573C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93857613BB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 18:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhDPSMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239524AbhDPSMz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 14:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9650A6137D;
        Fri, 16 Apr 2021 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618596750;
        bh=VH8D6jah6nSKkEw1AAooL+XObKytxlCwqiSuywSe5oo=;
        h=Date:From:To:Subject:From;
        b=eGFP6O9s8U0oIEiWfFefK/s/hlyKo9xiuBgJN2G6+4qLy42JkUBoQhXMWpZYG6CYq
         2QleCsinjPdTkHBdPpMzgiLjwJxLrJyKlpnlpvWefTUEgfA38vmuO4VD4CBB0sMSQ8
         Ei9q4np7QE6+PaOSKqZasxdbhBNhuhdECk4svCDQ=
Date:   Fri, 16 Apr 2021 11:12:30 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com, osalvador@suse.de
Subject:  [to-be-updated]
 x86-kconfig-introduce-arch_mhp_memmap_on_memory_enable.patch removed from -mm
 tree
Message-ID: <20210416181230.t6JdW%akpm@linux-foundation.org>
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

Link: https://lkml.kernel.org/r/20210319092635.6214-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

