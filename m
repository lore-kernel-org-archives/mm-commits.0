Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636E6C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D55364E66
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBKSfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhBKSc4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E76264E77;
        Thu, 11 Feb 2021 18:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068260;
        bh=KcAcAr70n1IiJRBt9N+Y40srFRW/O8lP29TUxujBDnY=;
        h=Date:From:To:Subject:From;
        b=h+fF+EzseJBhSn32VgTRIUOeons42Axb72YqrdDHYHvfWtVCqDfR0+Og0TUnM1nc4
         y1ZQgWPO9Hw7JaAENo8LvA6STliq3c6mEWQOyEqNHX9IT8+oNmca+a+PgFc9Jglksj
         UlVYVSv/sAgfpYFbLfXcQMk+Y8ePHuxN73o6zwhE=
Date:   Thu, 11 Feb 2021 10:31:00 -0800
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, lkp@intel.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com
Subject:  [merged]
 selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch removed from
 -mm tree
Message-ID: <20210211183100.VWQEdhnyI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: rename file run_vmtests to run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-rename-file-run_vmtests-to-run_vmtestssh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rong Chen <rong.a.chen@intel.com>
Subject: selftests/vm: rename file run_vmtests to run_vmtests.sh

Commit c2aa8afc36fa has renamed run_vmtests in Makefile, but the file
still uses the old name.

The kernel test robot reported the following issue:

 # selftests: vm: run_vmtests.sh
 # Warning: file run_vmtests.sh is missing!
 not ok 1 selftests: vm: run_vmtests.sh

Link: https://lkml.kernel.org/r/20210205085507.1479894-1-rong.a.chen@intel.com
Fixes: c2aa8afc36fa (selftests/vm: rename run_vmtests --> run_vmtests.sh)
Signed-off-by: Rong Chen <rong.a.chen@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/{run_vmtests => run_vmtests.sh} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/testing/selftests/vm/{run_vmtests => run_vmtests.sh} (100%)

diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests.sh
similarity index 100%
rename from tools/testing/selftests/vm/run_vmtests
rename to tools/testing/selftests/vm/run_vmtests.sh


Patches currently in -mm which might be from rong.a.chen@intel.com are


