Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EC0C46467
	for <mm-commits@archiver.kernel.org>; Thu,  5 Jan 2023 01:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjAEB6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Jan 2023 20:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjAEB6u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2023 20:58:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8C930555
        for <mm-commits@vger.kernel.org>; Wed,  4 Jan 2023 17:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD7F9B81981
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 01:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ADDC433D2;
        Thu,  5 Jan 2023 01:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672883926;
        bh=fQvHkNZdNeP3HIBxb6fVxjPHAf0XSnJp0Ua29BVBiaM=;
        h=Date:To:From:Subject:From;
        b=nYgqr8nxgYelaqxQrGUifYbvkHnzXFcbcH52c7rldGb3taOqQq1v8wlhZmdWTrPPi
         rqy/dz9kG+0zMhjJtK+JyhS88BeBN1Hy81XJdI9am9G8ImjZcSh9UB/id+HOR6aG5U
         hn4DV/Oj4eGwTVHjDKNH/ONNRvohJFKLpzfr4wTs=
Date:   Wed, 04 Jan 2023 17:58:45 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, joe@perches.com,
        dfustini@baylibre.com, colin.i.king@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spelling-add-a-few-more-typos.patch added to mm-nonmm-unstable branch
Message-Id: <20230105015846.92ADDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling: add a few more typos
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spelling-add-a-few-more-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spelling-add-a-few-more-typos.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: scripts/spelling: add a few more typos
Date: Wed, 4 Jan 2023 18:40:17 +0000

Add a few more typos that found from real patches[1,2] to 'spelling' file.

[1] https://lore.kernel.org/linux-mm/4bc4ab74-3ccd-f892-b387-d48451463d3c@huawei.com/
[2] https://lore.kernel.org/damon/20221228174621.34868-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20230104184017.1724-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Drew Fustini <dfustini@baylibre.com>
Cc: Joe Perches <joe@perches.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/spelling.txt~scripts-spelling-add-a-few-more-typos
+++ a/scripts/spelling.txt
@@ -664,11 +664,13 @@ feauture||feature
 feautures||features
 fetaure||feature
 fetaures||features
+fetcing||fetching
 fileystem||filesystem
 fimrware||firmware
 fimware||firmware
 firmare||firmware
 firmaware||firmware
+firtly||firstly
 firware||firmware
 firwmare||firmware
 finanize||finalize
@@ -1559,6 +1561,7 @@ tunning||tuning
 ture||true
 tyep||type
 udpate||update
+updtes||updates
 uesd||used
 unknwon||unknown
 uknown||unknown
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
scripts-spelling-add-a-few-more-typos.patch

