Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC82AC38147
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 00:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjARAnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjARAmH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 19:42:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457573CE07
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 16:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D45406158B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 00:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384AEC433EF;
        Wed, 18 Jan 2023 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674001307;
        bh=vl6FBLOw756aR+MQgABWEakpu5yVfw8e28k/qmNfSRU=;
        h=Date:To:From:Subject:From;
        b=gu5t7uvUkPAOtxw2+xZSw9F6kvfaoVzciFWbOyqt7pc08ZDNlr6l53clWVw7UGa/6
         AGDV2fEHL2KSonXOeIdr9SBsssFYGrMm2483ZAX7pXXGXw/xoYNwykWUnjNWcG9NAp
         tf2Ovlk/8SKooI7VXjoU29ZNEwznAaDE+kpX4Lng=
Date:   Tue, 17 Jan 2023 16:21:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_evictable-fix.patch added to mm-unstable branch
Message-Id: <20230118002147.384AEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-page_evictable-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_evictable-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_evictable-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-page_evictable-fix
Date: Tue Jan 17 04:20:34 PM PST 2023

fix Documentation/mm/unevictable-lru.rst underlining

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
  Link: https://lkml.kernel.org/r/20230117145106.585b277b@canb.auug.org.au
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/unevictable-lru.rst~mm-remove-page_evictable-fix
+++ a/Documentation/mm/unevictable-lru.rst
@@ -183,7 +183,7 @@ VM_LOCKED VMA, or found in a VMA being V
 
 
 Vmscan's Handling of Unevictable Folios
---------------------------------------
+---------------------------------------
 
 If unevictable folios are culled in the fault path, or moved to the unevictable
 list at mlock() or mmap() time, vmscan will not encounter the folios until they
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-fix.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3.patch
mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix-3-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
mm-memcontrol-deprecate-charge-moving-fix.patch
mm-swap-convert-deactivate_page-to-folio_deactivate-fix.patch
mm-uffd-detect-pgtable-allocation-failures-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

