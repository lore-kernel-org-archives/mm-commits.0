Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6A1C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJCVPc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJCVN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC61140BB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D70AEB81613
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93440C433D6;
        Mon,  3 Oct 2022 21:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831365;
        bh=1+j3X4Cp4PpvFFF1F3hfDwGvxW6SFr4PaN221sxO334=;
        h=Date:To:From:Subject:From;
        b=ghmocM2i5+5EmZ8HgcJ95nHUtBw28WUE0OZWlvvL7up3YH45JHZdDNsca6/l5E55l
         q4XmiE9FvjCrf09y/GFlb/PJhJE1MtSJ2P9dp2aJoniKtN+x1Rf1uhCBGXts/y4z/p
         nDgWV4Wn4cZ4itTnDkRgEB18TLJWBYdoHcvXBmC0=
Date:   Mon, 03 Oct 2022 14:09:24 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shiyn.lin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-fix-typos.patch removed from -mm tree
Message-Id: <20221003210925.93440C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: fix typos
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-fix-typos.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chih-En Lin <shiyn.lin@gmail.com>
Subject: mm/page_table_check: fix typos
Date: Fri, 16 Sep 2022 17:04:34 +0800

Link: https://lkml.kernel.org/r/20220916090434.701194-1-shiyn.lin@gmail.com
Signed-off-by: Chih-En Lin <shiyn.lin@gmail.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-fix-typos
+++ a/mm/page_table_check.c
@@ -53,7 +53,7 @@ static struct page_table_check *get_page
 }
 
 /*
- * An enty is removed from the page table, decrement the counters for that page
+ * An entry is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
  */
 static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
@@ -87,7 +87,7 @@ static void page_table_check_clear(struc
 }
 
 /*
- * A new enty is added to the page table, increment the counters for that page
+ * A new entry is added to the page table, increment the counters for that page
  * verify that it is of correct type and is not being mapped with a different
  * type to a different process.
  */
_

Patches currently in -mm which might be from shiyn.lin@gmail.com are


