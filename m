Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF85C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 30 May 2022 20:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiE3U0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 May 2022 16:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiE3U0s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 May 2022 16:26:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789AF46161
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 13:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A9FFB80DB4
        for <mm-commits@vger.kernel.org>; Mon, 30 May 2022 20:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA88C3411D;
        Mon, 30 May 2022 20:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653942404;
        bh=rfXe/nzGLUWR+iNf221MxzQc62E7fC3fDc22HVZayqM=;
        h=Date:To:From:Subject:From;
        b=DJvZgsuJu9E35UlEA8SN72SgcEToBgdIuWWapAODQtqmD36TGci+ydPfwI8a9k/iU
         g7EoUi8dDHbbGPemtOypLRYQ2bb+EKtoSnNsQfOF9kgcGy5r2w3cKdl5BbGFtS76o0
         DTfy0RF2ZDSWzb2F5bY7wcAkGAGtjxkCBoqwlgjs=
Date:   Mon, 30 May 2022 13:26:43 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-maintainer-information-for-z3fold.patch added to mm-hotfixes-unstable branch
Message-Id: <20220530202643.EAA88C3411D@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add maintainer information for z3fold
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-maintainer-information-for-z3fold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-maintainer-information-for-z3fold.patch

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
Subject: MAINTAINERS: add maintainer information for z3fold
Date: Mon, 30 May 2022 19:45:05 +0800

Add the maintainer information for the z3fold compressed page allocator. 
Also Add myself as a reviewer.

Link: https://lkml.kernel.org/r/20220530114505.52367-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS~maintainers-add-maintainer-information-for-z3fold
+++ a/MAINTAINERS
@@ -21928,6 +21928,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zbud.c
 
+Z3FOLD COMPRESSED PAGE ALLOCATOR
+M:	Vitaly Wool <vitaly.wool@konsulko.com>
+R:	Miaohe Lin <linmiaohe@huawei.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/z3fold.c
+
 ZD1211RW WIRELESS DRIVER
 M:	Ulrich Kunitz <kune@deine-taler.de>
 L:	linux-wireless@vger.kernel.org
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-maintainer-information-for-z3fold.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch

