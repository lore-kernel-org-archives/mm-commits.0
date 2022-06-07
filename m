Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB51C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jun 2022 20:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353634AbiFGUC4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 16:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354266AbiFGUCb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 16:02:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07C01C14DA
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 11:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3199961252
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 18:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A10C385A2;
        Tue,  7 Jun 2022 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654626322;
        bh=a3l6FE6iwAvhD6v6pnuJ1TvM/qX8KkpztQWSxD+G0LA=;
        h=Date:To:From:Subject:From;
        b=VnmyNrS4veP5C6lRojKJ2qxF/GWHPgyQ61qd7zL4TRrLgHUIjtroq1dd4wlpqaA2V
         EVVWDEmvtJeVAPEO6lOyB0V0wd7WtHY5ALWtq2qjtpM2bI5gDtvVAv/NTG9BnbmFfC
         cd34XnvEZcMyvyoyXOpV7t6IUZ1ahXSzTjrgBzC4=
Date:   Tue, 07 Jun 2022 11:25:21 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-a-memory-failure-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20220607182522.84A10C385A2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Miaohe Lin as a memory-failure reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-a-memory-failure-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-a-memory-failure-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: MAINTAINERS: add Miaohe Lin as a memory-failure reviewer
Date: Tue, 7 Jun 2022 22:51:35 +0800

I have been focusing on mm for the past two years.  e.g.  fixing bugs,
cleaning up the code and reviewing.  I would like to help maintainers and
people working on memory-failure by reviewing their work.

Let me be Cc'd on patches related to memory-failure.

Link: https://lkml.kernel.org/r/20220607145135.38670-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-a-memory-failure-reviewer
+++ a/MAINTAINERS
@@ -9124,6 +9124,7 @@ F:	drivers/media/platform/st/sti/hva
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Naoya Horiguchi <naoya.horiguchi@nec.com>
+R:	Miaohe Lin <linmiaohe@huawei.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/hwpoison-inject.c
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch

