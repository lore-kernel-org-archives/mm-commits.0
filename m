Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4462FC6FA91
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiILDgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiILDdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B367A286FA
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FEEB80C80
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0756BC433D6;
        Mon, 12 Sep 2022 03:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953453;
        bh=p/qH5ShS6ZrSlJypIzmIgWjkRP9wzGT5aqj0Oxik08E=;
        h=Date:To:From:Subject:From;
        b=SzbDKBfWw04PvbIxkW4XNLn8HEIhjNq/pVfA5cEtdhk//nwS7R23bJZsBYjqAelZl
         hLIQVDzSnjy1WMuRKJISTDSIvbn7mJon4X4K1N3Ee7O+FnUVvSwf0wvRMIRNL7H4Iv
         L4bvt9ucA4Wq0F812QO0UXKVnmJOpvTt7db/B0gc=
Date:   Sun, 11 Sep 2022 20:30:52 -0700
To:     mm-commits@vger.kernel.org, axelrasmussen@google.com,
        tsahu@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-vm-remove-deleted-local_config-from-gitignore.patch removed from -mm tree
Message-Id: <20220912033053.0756BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest: vm: remove deleted local_config.* from .gitignore
has been removed from the -mm tree.  Its filename was
     selftest-vm-remove-deleted-local_config-from-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tarun Sahu <tsahu@linux.ibm.com>
Subject: selftest: vm: remove deleted local_config.* from .gitignore
Date: Thu, 1 Sep 2022 14:53:15 +0530

Commit d2d6cba5d6623 ("selftest: vm: remove orphaned references to
local_config.{h,mk}") took care of removing orphaned references.  This
commit removes local_config from .gitignore.

Parent patch commit 69007f156ba ("Kselftests: remove support of
libhugetlbfs from kselftests")

Link: https://lkml.kernel.org/r/20220901092315.33619-1-tsahu@linux.ibm.com
Signed-off-by: Tarun Sahu <tsahu@linux.ibm.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/vm/.gitignore~selftest-vm-remove-deleted-local_config-from-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -30,7 +30,6 @@ map_fixed_noreplace
 write_to_hugetlbfs
 hmm-tests
 memfd_secret
-local_config.*
 soft-dirty
 split_huge_page_test
 ksm_tests
_

Patches currently in -mm which might be from tsahu@linux.ibm.com are


