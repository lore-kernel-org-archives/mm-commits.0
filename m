Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3086C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBCFoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E1F60CA3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92ABB61D68
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB461C433D2;
        Fri,  3 Feb 2023 05:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403037;
        bh=c+wW2RzgMjKf2lhrHUL0BSbK7MCgdYJMk0+0tZpOWUo=;
        h=Date:To:From:Subject:From;
        b=vIpNu+C1Z3bwvh3umiwKGGQn52YFBdVXs7Kr8FikE4ZqXTt/6/FIJgxHx2sjR8FaY
         U5oH3gRBB/F+AGE2S0miXwzE2TXN/hVfAUxduH9AMNny/lPwhlA4ZCneUZxq3wQ+iP
         T/wzeftFM3vDNAY4j0tcHVAWON2s0IKb+W3z7yDw=
Date:   Thu, 02 Feb 2023 21:43:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        sfr@canb.auug.org.au, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-page_evictable-fix.patch removed from -mm tree
Message-Id: <20230203054356.EB461C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-remove-page_evictable-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-page_evictable-fix.patch

This patch was dropped because it was folded into mm-remove-page_evictable.patch

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

fsdax-dax_unshare_iter-should-return-a-valid-length-fix.patch
revert-squashfs-harden-sanity-check-in-squashfs_read_xattr_id_table.patch
mm-remove-page_evictable.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
mm-shrinkers-fix-deadlock-in-shrinker-debugfs-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

