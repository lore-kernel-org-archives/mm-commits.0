Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC14C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbiKOWdp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiKOWdD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:33:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D66431354
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1754BCE1841
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C754C433D6;
        Tue, 15 Nov 2022 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551555;
        bh=ABUzvIUqFaNUopsisbKdmTzZ51ZDZRETyZn5df7Inb8=;
        h=Date:To:From:Subject:From;
        b=no4xiUKSPTESe5BeFyDkthK4Xo4qXerRqCeYEZDzqJ3J7QX9hE1HJk6T8KsGO0hH5
         zqlysoC3TN+/88HJXU3STiim8hGRP6ERoylzZ3qvegTqgdk2Y7n+/WvshcuwQZ4fYr
         9MHrGhoaezlDt4E8XAhyBv6rYWdCzhYGf1d5Hheo=
Date:   Tue, 15 Nov 2022 14:32:34 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        zhaogongyi@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch removed from -mm tree
Message-Id: <20221115223235.4C754C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add local_config.h and local_config.mk to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhao Gongyi <zhaogongyi@huawei.com>
Subject: selftests/vm: add local_config.h and local_config.mk to .gitignore
Date: Thu, 3 Nov 2022 08:57:54 +0800

Add local_config.h and local_config.mk to .gitignore to avoid accidentally
checking it in.

Link: https://lkml.kernel.org/r/20221103005754.205420-1-zhaogongyi@huawei.com
Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-local_configh-and-local_configmk-to-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -33,3 +33,5 @@ memfd_secret
 soft-dirty
 split_huge_page_test
 ksm_tests
+local_config.h
+local_config.mk
_

Patches currently in -mm which might be from zhaogongyi@huawei.com are


