Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94FDC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjDRXR2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjDRXR2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C3744B5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2026601C3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ED3C433D2;
        Tue, 18 Apr 2023 23:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859846;
        bh=5k96iBVxTTBrU4djbV4JTgTJ5hSY7o92SvS4oav1X14=;
        h=Date:To:From:Subject:From;
        b=IpVWv5M3BJL2GHukA4akkroYkiucJsvlh9KwbsnAFsi3edLT1X4CVFJca93VJ9R7g
         BH23VKICjcCOKlX1KLCicrJRVY5RrFP7llJHzxSxeEYdZ200pChG67XpB5U6/E/bPs
         /rxMw9L59zrrASDnJY3w9fqdDPLBvX0T1KY50XM0=
Date:   Tue, 18 Apr 2023 16:17:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, urezki@gmail.com,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch removed from -mm tree
Message-Id: <20230418231726.35ED3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch

This patch was dropped because it was folded into lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
Date: Thu Mar 30 02:02:39 PM PDT 2023

fix whitespace, per Lorenzo

Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix
+++ a/lib/test_vmalloc.c
@@ -375,7 +375,7 @@ vm_map_ram_test(void)
 
 	nr_allocated = alloc_pages_bulk_array(GFP_KERNEL, map_nr_pages, pages);
 	if (nr_allocated != map_nr_pages)
-        goto cleanup;
+		goto cleanup;
 
 	/* Run the test loop. */
 	for (i = 0; i < test_loop_count; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

