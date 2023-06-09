Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC25C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjFIXOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjFIXN6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA5B2D52
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67EF465CC1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D89C433EF;
        Fri,  9 Jun 2023 23:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686352436;
        bh=cKQAYmQJfnlL0kJY7uFE5mbe12GJjLvphsOZLve/tBI=;
        h=Date:To:From:Subject:From;
        b=Pk+jjah2vW8JXIA1kMWoc8d0Xc0Y2i+Pw3CxnZ+fd2oC744Vg3ClfrrUlmmsfUC4R
         1ZD4FBCtN4CNHVDrlQYVCOb24MZGbbJBJY3IKS9FptlQawgngs9s1NmfcucxjNEWA1
         DPsoCKrkBOYrwF844QW/fBsMwJlHoq54JnGuySLE=
Date:   Fri, 09 Jun 2023 16:13:56 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, nphamcs@gmail.com,
        mtk.manpages@gmail.com, mpe@ellerman.id.au, hannes@cmpxchg.org,
        bfoster@redhat.com, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-add-selftests-for-cachestat-fix.patch removed from -mm tree
Message-Id: <20230609231356.B8D89C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: fix spelling mistake "trucate" -> "truncate"
has been removed from the -mm tree.  Its filename was
     selftests-add-selftests-for-cachestat-fix.patch

This patch was dropped because it was folded into selftests-add-selftests-for-cachestat.patch

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: selftests: fix spelling mistake "trucate" -> "truncate"
Date: Fri, 5 May 2023 12:08:55 +0100

There is a spelling mistake in a message. Fix it.

Link: https://lkml.kernel.org/r/20230505110855.2493457-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cachestat/test_cachestat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cachestat/test_cachestat.c~selftests-add-selftests-for-cachestat-fix
+++ a/tools/testing/selftests/cachestat/test_cachestat.c
@@ -191,7 +191,7 @@ bool test_cachestat_shmem(void)
 	}
 
 	if (ftruncate(fd, filesize)) {
-		ksft_print_msg("Unable to trucate shmem file.\n");
+		ksft_print_msg("Unable to truncate shmem file.\n");
 		ret = false;
 		goto close_fd;
 	}
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-add-selftests-for-cachestat.patch
scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

