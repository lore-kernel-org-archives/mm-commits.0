Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1DACDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjJRVXF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjJRVXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:23:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691EFB0
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:23:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A5FC433C8;
        Wed, 18 Oct 2023 21:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664183;
        bh=6D48Fn00WWzUM8g750G0MIJrRL0/w+vh4IJabSgL448=;
        h=Date:To:From:Subject:From;
        b=jyzXkCC2Cj2PW4olC/EyVKOrBcxKfFVdLk1OvE/qkAtKDsRduGb2YB+RrSoBqPugK
         Aj7453GIyuL6RzeC9O0Ih1773Pqdds196fEr0+C79nx6nSwJhy6oclxvlZfuvO0rMJ
         Y9xcW8roOGVDFJU7ttpy/UxZk1/IsmRUmDuKOYa4=
Date:   Wed, 18 Oct 2023 14:23:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, surenb@google.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix.patch removed from -mm tree
Message-Id: <20231018212303.02A5FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix.patch

This patch was dropped because it was folded into mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix
Date: Wed Oct 18 12:50:42 PM PDT 2023

fix kerneldoc

Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap-fix
+++ a/mm/rmap.c
@@ -1129,7 +1129,7 @@ int folio_total_mapcount(struct folio *f
 
 /**
  * folio_move_anon_rmap - move a folio to our anon_vma
- * @page:	The folio to move to our anon_vma
+ * @folio:	The folio to move to our anon_vma
  * @vma:	The vma the folio belongs to
  *
  * When a folio belongs exclusively to one process after a COW event,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-rmap-convert-page_move_anon_rmap-to-folio_move_anon_rmap.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mm-kmemleak-split-__create_object-into-two-functions-checkpatch-fixes.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

