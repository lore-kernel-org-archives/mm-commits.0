Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3BB3C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBCGvO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbjBCGvC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BA82BF3A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F194FB82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936B2C433D2;
        Fri,  3 Feb 2023 06:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407057;
        bh=LNFtodz2UXiHIccri1oxH/CD8xNXND53yPe8o3kATBU=;
        h=Date:To:From:Subject:From;
        b=cZ8nG+S5/AiXQGSR68YM1DycZebWhxVImjwHZpHyBFdBR8huddFV9V/oHIn6hAZza
         N4l+O0sf1FetgD/SF3B/E9qg6Iy4sKVhUDDq+JPf6YE/LVTK9BLzGEJ5qhm50o+MZq
         df+ATvdi0otEELe3YIFvJxs5Bhp7q8qKbU9sf7Us=
Date:   Thu, 02 Feb 2023 22:50:57 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, joe@perches.com,
        dfustini@baylibre.com, colin.i.king@gmail.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spelling-add-a-few-more-typos.patch removed from -mm tree
Message-Id: <20230203065057.936B2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling: add a few more typos
has been removed from the -mm tree.  Its filename was
     scripts-spelling-add-a-few-more-typos.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


