Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E16C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiLAADn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiLAACC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF7389AD3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA00761E22
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E873FC433D7;
        Thu,  1 Dec 2022 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852866;
        bh=CvfzQ4wz5fvdMKQBfNZtHIbaNUnUdKX2lhdjbjJHcaI=;
        h=Date:To:From:Subject:From;
        b=zqK6v/t0ymbxh6kB+YKZHbQdF/WwyfJ3NUXHUJ05nKmF+APZSJczojJDkL9dQtzzh
         E+P2VTwzlO9W6/Wa1xC+Onjkj7cuHpJ20PpAh/WHR1sXYcBOiEhfB/6+4LjOpxj+xM
         9P3/mfqUCUGUMKdgCngbwX8A0olJ4d+1XNoVUP6A=
Date:   Wed, 30 Nov 2022 16:01:05 -0800
To:     mm-commits@vger.kernel.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-vm-page_owner-ignore-page_owner_sort-binary.patch removed from -mm tree
Message-Id: <20221201000105.E873FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/page_owner: ignore page_owner_sort binary
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner-ignore-page_owner_sort-binary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rong Tao <rongtao@cestc.cn>
Subject: tools/vm/page_owner: ignore page_owner_sort binary
Date: Tue, 8 Nov 2022 19:53:48 +0800

page_owner_sort was introduced since commit 48c96a368579 ("mm/page_owner:
keep track of page owners"), and we should ignore it.

Link: https://lkml.kernel.org/r/tencent_F6CAC0ABE16839E2B2419BD07316DA65BB06@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/vm/.gitignore~tools-vm-page_owner-ignore-page_owner_sort-binary
+++ a/tools/vm/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 slabinfo
 page-types
+page_owner_sort
_

Patches currently in -mm which might be from rongtao@cestc.cn are

radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

